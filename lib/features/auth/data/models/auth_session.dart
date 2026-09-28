import 'user_model.dart';

final class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.expiresAt,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final rawExpiresAt = json['expires_at'] ?? json['expiresAt'];
    final expiresIn = int.tryParse(
      (json['expires_in'] ?? json['expiresIn'] ?? '').toString(),
    );
    final rawUser = json['user'];

    return AuthSession(
      accessToken: (json['access_token'] ?? json['accessToken'] ?? '').toString(),
      refreshToken:
          (json['refresh_token'] ?? json['refreshToken'] ?? '').toString(),
      user: UserModel.fromJson(
        rawUser is Map<String, dynamic> ? rawUser : <String, dynamic>{},
      ),
      expiresAt: rawExpiresAt == null
          ? (expiresIn == null
              ? null
              : DateTime.now().add(Duration(seconds: expiresIn)))
          : DateTime.tryParse(rawExpiresAt.toString()),
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
  final UserModel user;

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!.toLocal());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'access_token': accessToken,
        'refresh_token': refreshToken,
        if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
        'user': user.toJson(),
      };
}
