import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/app_failure.dart';
import '../../business/domain/business_repository.dart';
import '../../business/domain/demo_qr.dart';
import '../../business/domain/promotion.dart';
import '../../discover/domain/business.dart';
import '../../discover/domain/discover_repository.dart';
import '../../wallet/data/card_cache.dart';
import '../../wallet/domain/loyalty_card.dart';
import '../../wallet/domain/wallet_repository.dart';
import 'demo_seed.dart';

/// Local sandbox only. A single persisted document makes each demo mutation
/// atomic. It must never be used as the authority for a real loyalty balance.
class DemoRepository
    implements WalletRepository, BusinessRepository, DiscoverRepository {
  DemoRepository(this._prefs, this._cache, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now {
    _cards = seedCards(_clock());
    _restore();
  }

  final SharedPreferences _prefs;
  final CardCache _cache;
  final DateTime Function() _clock;
  static const storageKey = 'demo.database.v1';
  late List<LoyaltyCard> _cards;
  List<Promotion> _promotions = [];
  Set<String> _operations = {};
  Future<void> _tail = Future<void>.value();

  void _restore() {
    final raw = _prefs.getString(storageKey);
    if (raw == null) {
      return;
    }
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final cards = (data['cards'] as List<dynamic>)
          .map((item) => LoyaltyCard.fromJson(item as Map<String, dynamic>))
          .toList();
      final expected = {
        for (final card in seedCards(_clock())) card.id: card.businessId,
      };
      if (cards.length != expected.length ||
          cards.any((card) => expected[card.id] != card.businessId) ||
          cards.any((card) =>
              card.target < 1 ||
              card.target > 20 ||
              card.stamps < 0 ||
              card.redeemed < 0) ||
          cards.map((card) => card.id).toSet().length != 3) {
        throw const FormatException('Invalid demo database');
      }
      final promotions = (data['promotions'] as List<dynamic>)
          .map((item) => Promotion.fromJson(item as Map<String, dynamic>))
          .toList();
      final operations =
          (data['operations'] as List<dynamic>).cast<String>().toSet();
      _cards = cards;
      _promotions = promotions;
      _operations = operations;
    } on Object {
      // Recover demo fixtures in memory; the next mutation overwrites bad data.
      _cards = seedCards(_clock());
      _promotions = [];
      _operations = {};
    }
  }

  Future<void> _serial(Future<void> Function() action) {
    final next = _tail.then((_) => action());
    _tail = next.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return next;
  }

  Future<void> _commit({
    List<LoyaltyCard>? cards,
    List<Promotion>? promotions,
    Set<String>? operations,
  }) async {
    final nextCards = cards ?? _cards;
    final nextPromotions = promotions ?? _promotions;
    final nextOperations = operations ?? _operations;
    final saved = await _prefs.setString(
        storageKey,
        jsonEncode({
          'cards': nextCards.map((card) => card.toJson()).toList(),
          'promotions': nextPromotions.map((promo) => promo.toJson()).toList(),
          'operations': nextOperations.toList(),
        }));
    if (!saved) {
      throw const AppFailure('No se pudo guardar. Inténtalo de nuevo.');
    }
    _cards = nextCards;
    _promotions = nextPromotions;
    _operations = nextOperations;
    // Cache failure must not turn a successful transaction into a retry.
    try {
      await _cache.write(demoMemberId, _cards, _clock());
    } on Object {
      // Source of truth for DEMO remains the persisted local database.
    }
  }

  @override
  Future<CardSnapshot> cards(String userId, {required bool offline}) async {
    _assertMember(userId);
    await _tail;
    if (offline) {
      final cached = await _cache.read(userId);
      if (cached != null) {
        return cached;
      }
    }
    final now = _clock();
    try {
      await _cache.write(userId, _cards, now);
    } on Object {
      // A read can still succeed without writable cache storage.
    }
    return CardSnapshot(
        cards: List.unmodifiable(_cards), savedAt: now, fromCache: offline);
  }

  void _assertMember(String userId) {
    if (userId != demoMemberId) {
      throw const AppFailure('Cliente demo no válido.');
    }
  }

  int _cardIndex(String id) {
    final index = _cards.indexWhere((card) => card.id == id);
    if (index < 0) {
      throw const AppFailure('No encontramos esa tarjeta.');
    }
    return index;
  }

  @override
  Future<void> redeem(String userId, String cardId, String operationId) =>
      _serial(() async {
        _assertMember(userId);
        final operation = 'redeem:$userId:$cardId:$operationId';
        if (_operations.contains(operation)) {
          return;
        }
        final index = _cardIndex(cardId);
        final card = _cards[index];
        if (!card.canRedeem) {
          throw const AppFailure('Aún faltan sellos para canjear.');
        }
        final next = [..._cards];
        next[index] = card.copyWith(
          stamps: card.stamps - card.target,
          redeemed: card.redeemed + 1,
          updatedAt: _clock(),
        );
        await _commit(cards: next, operations: {..._operations, operation});
      });

  @override
  Future<void> registerPurchase({
    required String businessId,
    required String qr,
    required String operationId,
  }) =>
      _serial(() async {
        final decoded = DemoQr.parse(qr);
        _assertMember(decoded.memberId);
        final index = _cardIndex(decoded.cardId);
        final card = _cards[index];
        if (businessId != demoBusinessId || card.businessId != businessId) {
          throw const AppFailure('La tarjeta pertenece a otro negocio.');
        }
        final operation = 'purchase:$businessId:$operationId';
        if (_operations.contains(operation)) {
          return;
        }
        final next = [..._cards];
        next[index] =
            card.copyWith(stamps: card.stamps + 1, updatedAt: _clock());
        await _commit(cards: next, operations: {..._operations, operation});
      });

  @override
  Future<void> saveCard(String businessId, LoyaltyCard card) =>
      _serial(() async {
        final index = _cardIndex(card.id);
        final current = _cards[index];
        if (businessId != demoBusinessId ||
            current.businessId != businessId ||
            card.businessId != businessId) {
          throw const AppFailure('No puedes editar esta tarjeta.');
        }
        if (card.target < 1 ||
            card.target > 20 ||
            card.reward.trim().isEmpty ||
            card.reward.length > 120) {
          throw const AppFailure(
              'Revisa la recompensa y la meta (1 a 20 sellos).');
        }
        final next = [..._cards];
        // A designer can never overwrite the customer's balance.
        next[index] = current.copyWith(
          reward: card.reward.trim(),
          target: card.target,
          color: card.color,
          symbol: card.symbol,
          logoPath: card.logoPath,
          backgroundPath: card.backgroundPath,
          stampPath: card.stampPath,
          updatedAt: _clock(),
        );
        await _commit(cards: next);
      });

  @override
  Future<List<Business>> businesses() async =>
      List.unmodifiable(demoBusinesses);

  @override
  Future<List<Promotion>> promotions() async {
    await _tail;
    return List.unmodifiable(_promotions);
  }

  @override
  Future<void> savePromotion(String businessId, Promotion promotion) =>
      _serial(() async {
        if (businessId != demoBusinessId ||
            promotion.businessId != businessId) {
          throw const AppFailure('No puedes publicar para este negocio.');
        }
        if (promotion.title.trim().isEmpty ||
            promotion.title.length > 70 ||
            promotion.description.trim().isEmpty ||
            promotion.description.length > 500 ||
            !promotion.expiresAt.isAfter(_clock())) {
          throw const AppFailure(
              'Revisa la promoción y su fecha de vencimiento.');
        }
        await _commit(promotions: [
          ..._promotions.where((item) => item.id != promotion.id),
          promotion,
        ]);
      });

  @override
  Future<void> deletePromotion(String businessId, String id) =>
      _serial(() async {
        if (businessId != demoBusinessId) {
          throw const AppFailure('Negocio no válido.');
        }
        await _commit(
            promotions: _promotions
                .where((promo) =>
                    !(promo.id == id && promo.businessId == businessId))
                .toList());
      });

  Future<void> reset() => _serial(() async {
        await _commit(
            cards: seedCards(_clock()), promotions: [], operations: {});
      });
}
