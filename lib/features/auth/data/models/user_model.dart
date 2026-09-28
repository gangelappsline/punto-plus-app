final class UserModel {
  const UserModel({
    required this.id,
    required this.displayName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.points = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? json['user_id'] ?? '').toString(),
        displayName: (json['display_name'] ??
                json['displayName'] ??
                json['name'] ??
                '')
            .toString(),
        email: json['email']?.toString(),
        phone: (json['phone'] ?? json['mobile'])?.toString(),
        avatarUrl: (json['avatar_url'] ?? json['avatarUrl'])?.toString(),
        points: int.tryParse((json['points'] ?? 0).toString()) ?? 0,
      );

  final String id;
  final String displayName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final int points;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'display_name': displayName,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'points': points,
      };
}
