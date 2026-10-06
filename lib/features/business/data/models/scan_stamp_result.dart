import '../../../../core/utils/json.dart';

/// Resultado de escanear el QR de un cliente y registrar un sello.
final class ScanStampResult {
  const ScanStampResult({
    required this.customerName,
    required this.cardName,
    required this.stampsCount,
    required this.requiredStamps,
    this.isCompleted = false,
    this.rewardUnlocked = false,
    this.businessName,
    this.stampId,
    this.createdAt,
    this.message,
  });

  factory ScanStampResult.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> customer = Json.map(
      Json.pick(json, <String>['customer', 'user', 'client']),
    );
    final Map<String, dynamic> card = Json.map(
      Json.pick(json, <String>['loyalty_card', 'card', 'customer_card']),
    );
    final Map<String, dynamic> business = Json.map(
      Json.pick(json, <String>['business', 'business_info']),
    );

    final int stampsCount = Json.integer(
      Json.pick(json, <String>['stamps_count', 'stampsCount', 'stamps']),
    );
    final int requiredStamps = Json.integer(
      Json.pick(json, <String>['required_stamps', 'requiredStamps']),
      fallback: Json.integer(card['required_stamps']),
    );

    return ScanStampResult(
      customerName: Json.text(
        Json.pick(json, <String>['customer_name', 'customerName']) ??
            customer['display_name'] ??
            customer['name'],
        fallback: 'Cliente',
      ),
      cardName: Json.text(
        Json.pick(json, <String>['card_name', 'cardName']) ?? card['name'],
        fallback: 'Tarjeta',
      ),
      stampsCount: stampsCount,
      requiredStamps: requiredStamps,
      isCompleted: Json.boolean(
        Json.pick(json, <String>['is_completed', 'isCompleted', 'completed']),
        fallback: requiredStamps > 0 && stampsCount >= requiredStamps,
      ),
      rewardUnlocked: Json.boolean(
        Json.pick(
          json,
          <String>['reward_unlocked', 'rewardUnlocked', 'can_redeem'],
        ),
        fallback: requiredStamps > 0 && stampsCount >= requiredStamps,
      ),
      businessName: Json.textOrNull(
        Json.pick(json, <String>['business_name', 'businessName']) ??
            business['name'],
      ),
      stampId: Json.textOrNull(
        Json.pick(json, <String>['stamp_id', 'stampId', 'id']),
      ),
      createdAt: Json.dateTimeOrNull(
        Json.pick(json, <String>['created_at', 'createdAt', 'stamped_at']),
      ),
      message: Json.textOrNull(json['message']),
    );
  }

  final String customerName;
  final String cardName;
  final int stampsCount;
  final int requiredStamps;
  final bool isCompleted;
  final bool rewardUnlocked;
  final String? businessName;
  final String? stampId;
  final DateTime? createdAt;
  final String? message;

  double get progress =>
      requiredStamps <= 0 ? 0 : (stampsCount / requiredStamps).clamp(0, 1);
}
