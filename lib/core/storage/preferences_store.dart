import 'dart:convert';

import '../models/app_preferences.dart';
import 'key_value_store.dart';

/// Persiste las preferencias del usuario entre sesiones.
final class PreferencesStore {
  const PreferencesStore(this._store);

  static const String storageKey = 'app.preferences';

  final KeyValueStore _store;

  Future<AppPreferences> load() async {
    final String? raw = await _store.read(storageKey);
    if (raw == null || raw.isEmpty) return const AppPreferences();
    try {
      final dynamic decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return AppPreferences.fromJson(decoded);
      }
      if (decoded is Map) {
        return AppPreferences.fromJson(
          decoded.map<String, dynamic>(
            (dynamic key, dynamic value) =>
                MapEntry<String, dynamic>(key.toString(), value),
          ),
        );
      }
    } on FormatException {
      await _store.delete(storageKey);
    }
    return const AppPreferences();
  }

  Future<void> save(AppPreferences preferences) =>
      _store.write(storageKey, jsonEncode(preferences.toJson()));

  Future<void> clear() => _store.delete(storageKey);
}
