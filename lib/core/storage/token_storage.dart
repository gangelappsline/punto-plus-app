import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/auth_session.dart';

final class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'auth.access_token';
  static const String _refreshTokenKey = 'auth.refresh_token';
  static const String _expiresAtKey = 'auth.expires_at';
  static const String _sessionKey = 'auth.session';

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<AuthSession?> readSession() async {
    final rawSession = await _storage.read(key: _sessionKey);
    if (rawSession == null || rawSession.isEmpty) return null;
    try {
      return AuthSession.fromJson(
        jsonDecode(rawSession) as Map<String, dynamic>,
      );
    } on FormatException {
      await clear();
      return null;
    }
  }

  Future<void> saveSession(AuthSession session) async {
    await Future.wait(<Future<void>>[
      _storage.write(key: _accessTokenKey, value: session.accessToken),
      _storage.write(key: _refreshTokenKey, value: session.refreshToken),
      _storage.write(
        key: _expiresAtKey,
        value: session.expiresAt?.toIso8601String(),
      ),
      _storage.write(key: _sessionKey, value: jsonEncode(session.toJson())),
    ]);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) async {
    final currentSession = await readSession();
    final resolvedRefreshToken =
        refreshToken ?? currentSession?.refreshToken ?? await readRefreshToken();

    if (currentSession != null && resolvedRefreshToken != null) {
      await saveSession(
        AuthSession(
          accessToken: accessToken,
          refreshToken: resolvedRefreshToken,
          expiresAt: expiresAt ?? currentSession.expiresAt,
          user: currentSession.user,
        ),
      );
      return;
    }

    await Future.wait(<Future<void>>[
      _storage.write(key: _accessTokenKey, value: accessToken),
      if (resolvedRefreshToken != null)
        _storage.write(key: _refreshTokenKey, value: resolvedRefreshToken),
      if (expiresAt != null)
        _storage.write(key: _expiresAtKey, value: expiresAt.toIso8601String()),
    ]);
  }

  Future<void> clear() async {
    await Future.wait(<Future<void>>[
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _expiresAtKey),
      _storage.delete(key: _sessionKey),
    ]);
  }
}
