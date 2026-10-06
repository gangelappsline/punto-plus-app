import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/data_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/customer_card.dart';
import '../../data/models/customer_card_qr.dart';
import '../../data/models/stamp.dart';
import '../../domain/repositories/cards_repository.dart';

/// Tarjetas de fidelidad del cliente.
final cardsControllerProvider =
    AsyncNotifierProvider<CardsController, List<CustomerCardModel>>(
  CardsController.new,
);

final class CardsController extends AsyncNotifier<List<CustomerCardModel>> {
  late CardsRepository _repository;

  @override
  Future<List<CustomerCardModel>> build() {
    _repository = ref.watch(cardsRepositoryProvider);
    return _load();
  }

  Future<List<CustomerCardModel>> _load({bool force = false}) async {
    final Result<List<CustomerCardModel>> result =
        await _repository.fetchCards(forceRefresh: force);
    return switch (result) {
      Success<List<CustomerCardModel>>(:final value) => value,
      Failure<List<CustomerCardModel>>(:final error) => throw error,
    };
  }

  /// Vuelve a cargar las tarjetas.
  Future<void> refresh({bool force = true}) async {
    state = const AsyncValue<List<CustomerCardModel>>.loading();
    state = await AsyncValue.guard(() => _load(force: force));
  }

  /// Une al cliente a una tarjeta con el código o QR del negocio.
  Future<CustomerCardModel> join(String code) async {
    final Result<CustomerCardModel> result = await _repository.join(code);
    final CustomerCardModel card = switch (result) {
      Success<CustomerCardModel>(:final value) => value,
      Failure<CustomerCardModel>(:final error) => throw error,
    };
    final List<CustomerCardModel> current =
        state.valueOrNull ?? <CustomerCardModel>[];
    final bool alreadyThere =
        current.any((CustomerCardModel item) => item.id == card.id);
    state = AsyncValue<List<CustomerCardModel>>.data(
      <CustomerCardModel>[
        if (!alreadyThere) card,
        ...current,
      ],
    );
    return card;
  }
}

/// Suma de sellos obtenidos en todas las tarjetas.
final totalStampsProvider = Provider<int>((Ref ref) {
  final List<CustomerCardModel> cards =
      ref.watch(cardsControllerProvider).valueOrNull ?? <CustomerCardModel>[];
  return cards.fold(
    0,
    (int total, CustomerCardModel card) => total + card.stampsCount,
  );
});

/// Tarjetas completas listas para canjear.
final completedCardsProvider = Provider<List<CustomerCardModel>>((Ref ref) {
  final List<CustomerCardModel> cards =
      ref.watch(cardsControllerProvider).valueOrNull ?? <CustomerCardModel>[];
  return cards.where((CustomerCardModel card) => card.isCompleted).toList();
});

/// Detalle de una tarjeta (con respaldo en la caché local).
final cardDetailProvider =
    FutureProvider.family<CustomerCardModel, String>((Ref ref, String id) async {
  final Result<CustomerCardModel> result =
      await ref.watch(cardsRepositoryProvider).fetchCard(id);
  return switch (result) {
    Success<CustomerCardModel>(:final value) => value,
    Failure<CustomerCardModel>(:final error) => throw error,
  };
});

/// Historial de sellos de una tarjeta.
final cardStampsProvider =
    FutureProvider.family<List<StampModel>, String>((Ref ref, String id) async {
  final Result<List<StampModel>> result =
      await ref.watch(cardsRepositoryProvider).fetchStamps(id);
  return switch (result) {
    Success<List<StampModel>>(:final value) => value,
    Failure<List<StampModel>>(:final error) => throw error,
  };
});

/// Código QR temporal de una tarjeta.
final cardQrControllerProvider = AsyncNotifierProvider.family<CardQrController,
    CustomerCardQr, String>(CardQrController.new);

final class CardQrController
    extends FamilyAsyncNotifier<CustomerCardQr, String> {
  @override
  Future<CustomerCardQr> build(String arg) => _generate();

  Future<CustomerCardQr> _generate() async {
    final Result<CustomerCardQr> result =
        await ref.read(cardsRepositoryProvider).fetchQr(arg);
    return switch (result) {
      Success<CustomerCardQr>(:final value) => value,
      Failure<CustomerCardQr>(:final error) => throw error,
    };
  }

  /// Regenera el código cuando expira.
  Future<void> regenerate() async {
    state = const AsyncValue<CustomerCardQr>.loading();
    state = await AsyncValue.guard(_generate);
  }
}

/// Canjea la recompensa de una tarjeta completada.
Future<CustomerCardModel?> redeemCardReward(
  Ref ref,
  String cardId,
) async {
  final Result<CustomerCardModel?> result =
      await ref.read(cardsRepositoryProvider).redeem(cardId);
  return switch (result) {
    Success<CustomerCardModel?>(:final value) => value,
    Failure<CustomerCardModel?>(:final error) => throw error,
  };
}
