import '../../../../core/utils/json.dart';
import 'loyalty_card.dart';

/// Tarjeta de fidelidad con el progreso de un cliente.
final class CustomerCardModel {
  const CustomerCardModel({
    required this.id,
    required this.loyaltyCard,
    required this.stampsCount,
    required this.requiredStamps,
    this.isCompleted = false,
    this.isActive = true,
    this.qrCode,
    this.qrExpiresAt,
    this.completedAt,
    this.createdAt,
    this.expiresAt,
    this.lastStampAt,
  });

  factory CustomerCardModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> loyalty = Json.map(
      Json.pick(json, <String>['loyalty_card', 'loyaltyCard']),
    );

    final LoyaltyCardModel card = loyalty.isNotEmpty
        ? LoyaltyCardModel.fromJson(loyalty)
        : LoyaltyCardModel.fromJson(json);

    final int stampsCount = Json.integer(
      Json.pick(
        json,
        <String>['stamps_count', 'stampsCount', 'stamps', 'current_stamps'],
      ),
    );
    final int requiredStamps = Json.integer(
      Json.pick(json, <String>['required_stamps', 'requiredStamps']),
      fallback: card.requiredStamps,
    );

    return CustomerCardModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      loyaltyCard: card,
      stampsCount: stampsCount,
      requiredStamps: requiredStamps <= 0 ? card.requiredStamps : requiredStamps,
      isCompleted: Json.boolean(
        Json.pick(json, <String>['is_completed', 'isCompleted', 'completed']),
        fallback: stampsCount >= requiredStamps && requiredStamps > 0,
      ),
      isActive: Json.boolean(
        Json.pick(json, <String>['is_active', 'isActive']),
        fallback: true,
      ),
      qrCode: Json.textOrNull(
        Json.pick(json, <String>['qr_code', 'qrCode', 'code']),
      ),
      qrExpiresAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['qr_expires_at', 'qrExpiresAt']),
      ),
      completedAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['completed_at', 'completedAt']),
      ),
      createdAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['created_at', 'createdAt']),
      ),
      expiresAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['expires_at', 'expiresAt']),
      ),
      lastStampAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['last_stamp_at', 'lastStampAt']),
      ),
    );
  }

  final String id;
  final LoyaltyCardModel loyaltyCard;
  final int stampsCount;
  final int requiredStamps;
  final bool isCompleted;
  final bool isActive;
  final String? qrCode;
  final DateTime? qrExpiresAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? lastStampAt;

  String get businessName => loyaltyCard.displayBusinessName;

  int get remainingStamps {
    final int remaining = requiredStamps - stampsCount;
    return remaining < 0 ? 0 : remaining;
  }

  double get progress {
    if (requiredStamps <= 0) return 0;
    final double value = stampsCount / requiredStamps;
    return value.clamp(0, 1);
  }

  int get progressPercentage => (progress * 100).round();

  bool get hasFreshQr {
    final String? code = qrCode;
    if (code == null || code.isEmpty) return false;
    final DateTime? expiresAt = qrExpiresAt;
    if (expiresAt == null) return true;
    return expiresAt.isAfter(DateTime.now());
  }

  CustomerCardModel copyWith({
    int? stampsCount,
    bool? isCompleted,
    bool? isActive,
    String? qrCode,
    DateTime? qrExpiresAt,
    DateTime? completedAt,
    DateTime? lastStampAt,
  }) =>
      CustomerCardModel(
        id: id,
        loyaltyCard: loyaltyCard,
        stampsCount: stampsCount ?? this.stampsCount,
        requiredStamps: requiredStamps,
        isCompleted: isCompleted ?? this.isCompleted,
        isActive: isActive ?? this.isActive,
        qrCode: qrCode ?? this.qrCode,
        qrExpiresAt: qrExpiresAt ?? this.qrExpiresAt,
        completedAt: completedAt ?? this.completedAt,
        createdAt: createdAt,
        expiresAt: expiresAt,
        lastStampAt: lastStampAt ?? this.lastStampAt,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'loyalty_card': loyaltyCard.toJson(),
        'stamps_count': stampsCount,
        'required_stamps': requiredStamps,
        'is_completed': isCompleted,
        'is_active': isActive,
        if (qrCode != null) 'qr_code': qrCode,
        if (qrExpiresAt != null) 'qr_expires_at': qrExpiresAt!.toIso8601String(),
        if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
        if (lastStampAt != null)
          'last_stamp_at': lastStampAt!.toIso8601String(),
      };
}
