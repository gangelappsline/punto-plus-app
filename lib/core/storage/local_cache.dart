import 'dart:convert';

import 'key_value_store.dart';

/// Caché local mínima para funcionar con datos guardados cuando no hay red.
final class LocalCache {
  const LocalCache(this._store);

  static const String cardsKey = 'cache.customer_cards';
  static const String favoritesKey = 'cache.business_favorites';
  static const String referralKey = 'cache.referral';
  static const String nearbyKey = 'cache.nearby_businesses';

  final KeyValueStore _store;

  Future<void> saveList(String key, List<Map<String, dynamic>> items) =>
      _store.write(key, jsonEncode(items));

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final String? raw = await _store.read(key);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<dynamic, dynamic>>()
            .map(
              (Map<dynamic, dynamic> item) => item.map<String, dynamic>(
                (dynamic key, dynamic value) =>
                    MapEntry<String, dynamic>(key.toString(), value),
              ),
            )
            .toList();
      }
    } on FormatException {
      await _store.delete(key);
    }
    return <Map<String, dynamic>>[];
  }

  Future<void> saveMap(String key, Map<String, dynamic> value) =>
      _store.write(key, jsonEncode(value));

  Future<Map<String, dynamic>?> readMap(String key) async {
    final String? raw = await _store.read(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map<String, dynamic>(
          (dynamic key, dynamic value) =>
              MapEntry<String, dynamic>(key.toString(), value),
        );
      }
    } on FormatException {
      await _store.delete(key);
    }
    return null;
  }

  Future<void> saveIds(String key, Set<String> ids) =>
      _store.write(key, jsonEncode(ids.toList()));

  Future<Set<String>> readIds(String key) async {
    final String? raw = await _store.read(key);
    if (raw == null || raw.isEmpty) return <String>{};
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((dynamic id) => id.toString()).toSet();
      }
    } on FormatException {
      await _store.delete(key);
    }
    return <String>{};
  }

  Future<void> clear() => _store.clear();
}
