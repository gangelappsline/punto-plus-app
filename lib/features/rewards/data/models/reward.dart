import '../../../../core/utils/json.dart';

/// Estado de un premio dentro de la billetera del cliente.
enum RewardStatus {
  available,
  redeemed,
  expired;

  static RewardStatus fromName(String? value) => switch (value?.toLowerCase()) {
        'redeemed' || 'canjeado' || 'used' => RewardStatus.redeemed,
        'expired' || 'expirado' => RewardStatus.expired,
        _ => RewardStatus.available,
      };

  bool get isAvailable => this == RewardStatus.available;
}

/// Premio obtenido al completar una tarjeta de fidelidad.
final class RewardModel {
  const RewardModel({
    required this.id,
    required this.title,
    required this.status,
    this.description,
    this.imageUrl,
    this.businessId,
    this.businessName,
    this.businessLogoUrl,
    this.customerCardId,
    this.expiresAt,
    this.redeemedAt,
    this.createdAt,
    this.requiredStamps,
    this.code,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> business = Json.map(
      Json.pick(json, <String>['business', 'business_info']),
    );
    final Map<String, dynamic> card = Json.map(
      Json.pick(json, <String>['loyalty_card', 'card', 'customer_card']),
    );

    return RewardModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      title: Json.text(
        Json.pick(json, <String>['title', 'name', 'reward_description']),
        fallback: 'Recompensa',
      ),
      status: RewardStatus.fromName(
        Json.textOrNull(Json.pick(json, <String>['status', 'state'])),
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
      customerCardId: Json.textOrNull(
        Json.pick(json, <String>['customer_card_id', 'customerCardId']) ??
            card['id'],
      ),
      expiresAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['expires_at', 'expiresAt', 'valid_until']),
      ),
      redeemedAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['redeemed_at', 'redeemedAt']),
      ),
      createdAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['created_at', 'createdAt', 'unlocked_at']),
      ),
      requiredStamps: Json.integerOrNull(
        Json.pick(
          json,
          <String>['required_stamps', 'requiredStamps', 'stamps_required'],
        ),
      ),
      code: Json.textOrNull(
        Json.pick(json, <String>['code', 'redemption_code', 'qr_code']),
      ),
    );
  }

  final String id;
  final String title;
  final RewardStatus status;
  final String? description;
  final String? imageUrl;
  final String? businessId;
  final String? businessName;
  final String? businessLogoUrl;
  final String? customerCardId;
  final DateTime? expiresAt;
  final DateTime? redeemedAt;
  final DateTime? createdAt;
  final int? requiredStamps;
  final String? code;

  RewardStatus get resolvedStatus {
    if (status == RewardStatus.available &&
        expiresAt != null &&
        expiresAt!.isBefore(DateTime.now())) {
      return RewardStatus.expired;
    }
    return status;
  }

  RewardModel copyWith({
    RewardStatus? status,
    DateTime? redeemedAt,
    String? code,
  }) =>
      RewardModel(
        id: id,
        title: title,
        status: status ?? this.status,
        description: description,
        imageUrl: imageUrl,
        businessId: businessId,
        businessName: businessName,
        businessLogoUrl: businessLogoUrl,
        customerCardId: customerCardId,
        expiresAt: expiresAt,
        redeemedAt: redeemedAt ?? this.redeemedAt,
        createdAt: createdAt,
        requiredStamps: requiredStamps,
        code: code ?? this.code,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'status': status.name,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
        if (businessId != null) 'business_id': businessId,
        if (businessName != null) 'business_name': businessName,
        if (businessLogoUrl != null) 'business_logo_url': businessLogoUrl,
        if (customerCardId != null) 'customer_card_id': customerCardId,
        if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
        if (redeemedAt != null) 'redeemed_at': redeemedAt!.toIso8601String(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (requiredStamps != null) 'required_stamps': requiredStamps,
        if (code != null) 'code': code,
      };
}
