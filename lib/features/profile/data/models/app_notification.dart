import '../../../../core/utils/json.dart';

/// Tipo de aviso recibido por el usuario.
enum AppNotificationType {
  stamp,
  reward,
  promotion,
  generic;

  static AppNotificationType fromName(String? value) =>
      switch (value?.toLowerCase()) {
        'stamp' || 'stamps' || 'sello' => AppNotificationType.stamp,
        'reward' || 'premio' || 'reward_unlocked' => AppNotificationType.reward,
        'promotion' || 'promo' || 'promocion' => AppNotificationType.promotion,
        _ => AppNotificationType.generic,
      };
}

/// Notificación del centro de avisos.
final class AppNotificationModel {
  const AppNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.businessName,
    this.imageUrl,
    this.payload = const <String, dynamic>{},
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Json.map(json['data']);

    return AppNotificationModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      type: AppNotificationType.fromName(
        Json.textOrNull(Json.pick(json, <String>['type', 'kind'])),
      ),
      title: Json.text(
        Json.pick(json, <String>['title', 'subject']),
        fallback: '',
      ),
      body: Json.text(
        Json.pick(json, <String>['body', 'message', 'description']),
      ),
      createdAt: Json.dateTimeOrNull(
            Json.pick(json, <String>['created_at', 'createdAt', 'sent_at']),
          ) ??
          DateTime.now(),
      isRead: Json.boolean(
        Json.pick(json, <String>['is_read', 'isRead', 'read_at']),
      ),
      businessName: Json.textOrNull(
        Json.pick(json, <String>['business_name', 'businessName']) ??
            data['business_name'],
      ),
      imageUrl: Json.textOrNull(
        Json.pick(json, <String>['image_url', 'imageUrl']) ?? data['image_url'],
      ),
      payload: data,
    );
  }

  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? businessName;
  final String? imageUrl;
  final Map<String, dynamic> payload;

  AppNotificationModel copyWith({bool? isRead}) => AppNotificationModel(
        id: id,
        type: type,
        title: title,
        body: body,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
        businessName: businessName,
        imageUrl: imageUrl,
        payload: payload,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.name,
        'title': title,
        'body': body,
        'created_at': createdAt.toIso8601String(),
        'is_read': isRead,
        if (businessName != null) 'business_name': businessName,
        if (imageUrl != null) 'image_url': imageUrl,
        'data': payload,
      };
}
