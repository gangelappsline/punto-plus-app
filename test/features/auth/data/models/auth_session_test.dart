import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/features/auth/data/models/auth_session.dart';

void main() {
  group('AuthSession', () {
    test('parses a wrapped-compatible snake_case payload', () {
      final session = AuthSession.fromJson(<String, dynamic>{
        'access_token': 'access-token',
        'refresh_token': 'refresh-token',
        'expires_at': '2030-01-01T00:00:00.000Z',
        'user': <String, dynamic>{
          'id': 'user-1',
          'display_name': 'Ana Pérez',
          'points': 150,
        },
      });

      expect(session.accessToken, 'access-token');
      expect(session.refreshToken, 'refresh-token');
      expect(session.user.displayName, 'Ana Pérez');
      expect(session.user.points, 150);
      expect(session.expiresAt, DateTime.utc(2030));
    });

    test('supports camelCase aliases', () {
      final session = AuthSession.fromJson(<String, dynamic>{
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
        'user': <String, dynamic>{
          'id': 42,
          'displayName': 'Luis',
        },
      });

      expect(session.user.id, '42');
      expect(session.user.displayName, 'Luis');
    });
  });
}
