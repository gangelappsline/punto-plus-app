import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Almacenamiento clave/valor usado para preferencias y caché local.
abstract interface class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}

/// Implementación productiva con el almacenamiento seguro del sistema
/// (Keychain en iOS, EncryptedSharedPreferences en Android).
final class SecureKeyValueStore implements KeyValueStore {
  const SecureKeyValueStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}

/// Implementación en memoria para pruebas y previsualizaciones.
final class MemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);

  @override
  Future<void> clear() async => _values.clear();
}
