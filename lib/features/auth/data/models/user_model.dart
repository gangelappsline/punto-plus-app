import '../../../../core/utils/json.dart';

/// Papel del usuario dentro de la plataforma.
enum UserRole {
  customer,
  business,
  admin;

  static UserRole fromName(String? value) => switch (value?.toLowerCase()) {
        'business' || 'negocio' || 'owner' => UserRole.business,
        'admin' || 'administrador' => UserRole.admin,
        _ => UserRole.customer,
      };

  bool get isBusiness => this == UserRole.business || this == UserRole.admin;

  bool get isCustomer => this == UserRole.customer;
}

final class UserModel {
  const UserModel({
    required this.id,
    required this.displayName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.points = 0,
    this.role = UserRole.customer,
    this.emailVerifiedAt,
    this.createdAt,
    this.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dynamic role = Json.pick(json, <String>['role', 'user_type', 'type']);
    return UserModel(
      id: Json.text(Json.pick(json, <String>['id', 'user_id', 'uuid'])),
      displayName: Json.text(
        Json.pick(
          json,
          <String>['display_name', 'displayName', 'name', 'full_name'],
        ),
      ),
      email: Json.textOrNull(json['email']),
      phone: Json.textOrNull(Json.pick(json, <String>['phone', 'mobile'])),
      avatarUrl: Json.textOrNull(
        Json.pick(json, <String>['avatar_url', 'avatarUrl', 'avatar', 'photo']),
      ),
      points: Json.integer(
        Json.pick(json, <String>['points', 'loyalty_points', 'balance']),
      ),
      role: role is Map
          ? UserRole.fromName(Json.text(role['name'] ?? role['slug']))
          : UserRole.fromName(role?.toString()),
      emailVerifiedAt: Json.dateTimeOrNull(
        Json.pick(
          json,
          <String>['email_verified_at', 'emailVerifiedAt', 'verified_at'],
        ),
      ),
      createdAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['created_at', 'createdAt']),
      ),
      referralCode: Json.textOrNull(
        Json.pick(json, <String>['referral_code', 'referralCode']),
      ),
    );
  }

  final String id;
  final String displayName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final int points;
  final UserRole role;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final String? referralCode;

  bool get hasVerifiedEmail => emailVerifiedAt != null;

  bool get isBusiness => role.isBusiness;

  String get firstName {
    final String trimmed = displayName.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  /// Iniciales para el avatar cuando no hay imagen.
  String get initials {
    final List<String> parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  UserModel copyWith({
    String? displayName,
    String? email,
    String? phone,
    String? avatarUrl,
    int? points,
    UserRole? role,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    String? referralCode,
  }) =>
      UserModel(
        id: id,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        points: points ?? this.points,
        role: role ?? this.role,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        createdAt: createdAt ?? this.createdAt,
        referralCode: referralCode ?? this.referralCode,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'display_name': displayName,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'points': points,
        'role': role.name,
        if (emailVerifiedAt != null)
          'email_verified_at': emailVerifiedAt!.toIso8601String(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (referralCode != null) 'referral_code': referralCode,
      };
}
