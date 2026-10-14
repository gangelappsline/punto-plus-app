import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/loyalty_card.dart';

/// Non-sensitive snapshots only. Per-user, versioned, with corruption recovery.
class CardCache {
  CardCache(this._prefs);
  final SharedPreferences _prefs;
  String _key(String userId) => 'cards.v1.${Uri.encodeComponent(userId)}';

  Future<void> write(
      String userId, List<LoyaltyCard> cards, DateTime savedAt) async {
    final saved = await _prefs.setString(
        _key(userId),
        jsonEncode({
          'savedAt': savedAt.toIso8601String(),
          'cards': cards.map((card) => card.toJson()).toList(),
        }));
    if (!saved) {
      throw StateError('No se pudo guardar la caché.');
    }
  }

  Future<CardSnapshot?> read(String userId) async {
    final raw = _prefs.getString(_key(userId));
    if (raw == null) {
      return null;
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final cards = (json['cards'] as List<dynamic>)
          .map((item) => LoyaltyCard.fromJson(item as Map<String, dynamic>))
          .toList();
      if (cards.any(
          (card) => card.target < 1 || card.target > 20 || card.stamps < 0)) {
        throw const FormatException('Invalid cached card');
      }
      return CardSnapshot(
        cards: List.unmodifiable(cards),
        savedAt: DateTime.parse(json['savedAt'] as String),
        fromCache: true,
      );
    } on Object {
      await clear(userId);
      return null;
    }
  }

  Future<void> clear(String userId) async {
    await _prefs.remove(_key(userId));
  }
}
