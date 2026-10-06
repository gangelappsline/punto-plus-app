import '../../../../core/utils/json.dart';

/// Vigencia calculada de una promoción.
enum PromotionStatus {
  active,
  scheduled,
  expired,
  paused;

  bool get isVisible => this == PromotionStatus.active;
}

/// Promoción publicada por un negocio.
final class PromotionModel {
  const PromotionModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.businessId,
    this.businessName,
    this.businessLogoUrl,
    this.startsAt,
    this.endsAt,
    this.isActive = true,
    this.createdAt,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> business = Json.map(
      Json.pick(json, <String>['business', 'business_info']),
    );

    return PromotionModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      title: Json.text(
        Json.pick(json, <String>['title', 'name']),
        fallback: 'Promoción',
      ),
      description: Json.textOrNull(
        Json.pick(json, <String>['description', 'details']),
      ),
      imageUrl: Json.textOrNull(
        Json.pick(json, <String>['image_url', 'imageUrl', 'image']),
      ),
      businessId: Json.textOrNull(
        Json.pick(json, <String>['business_id', 'businessId']) ?? business['id'],
      ),
      businessName: Json.textOrNull(
        Json.pick(json, <String>['business_name', 'businessName']) ??
            business['name'],
      ),
      businessLogoUrl: Json.textOrNull(
        Json.pick(json, <String>['business_logo_url', 'businessLogoUrl']) ??
            business['logo_url'],
      ),
      startsAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['starts_at', 'startsAt', 'start_date']),
      ),
      endsAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['ends_at', 'endsAt', 'end_date', 'expires_at']),
      ),
      isActive: Json.boolean(
        Json.pick(json, <String>['is_active', 'isActive', 'active']),
        fallback: true,
      ),
      createdAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['created_at', 'createdAt']),
      ),
    );
  }

  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? businessId;
  final String? businessName;
  final String? businessLogoUrl;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final DateTime? createdAt;

  PromotionStatus statusAt([DateTime? reference]) {
    final DateTime now = reference ?? DateTime.now();
    if (!isActive) return PromotionStatus.paused;
    if (startsAt != null && startsAt!.isAfter(now)) {
      return PromotionStatus.scheduled;
    }
    if (endsAt != null && endsAt!.isBefore(now)) {
      return PromotionStatus.expired;
    }
    return PromotionStatus.active;
  }

  bool get isCurrentlyActive => statusAt().isVisible;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
        if (businessId != null) 'business_id': businessId,
        if (businessName != null) 'business_name': businessName,
        if (businessLogoUrl != null) 'business_logo_url': businessLogoUrl,
        if (startsAt != null) 'starts_at': startsAt!.toIso8601String(),
        if (endsAt != null) 'ends_at': endsAt!.toIso8601String(),
        'is_active': isActive,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      };
}
