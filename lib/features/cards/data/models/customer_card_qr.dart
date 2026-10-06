import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/json.dart';

/// Código QR temporal que el cliente muestra en el negocio.
final class CustomerCardQr {
  const CustomerCardQr({
    required this.code,
    required this.expiresAt,
    this.customerCardId,
    this.businessName,
    this.cardName,
  });

  factory CustomerCardQr.fromJson(
    Map<String, dynamic> json, {
    String? customerCardId,
  }) {
    final DateTime expiresAt = Json.dateTimeOrNull(
          Json.pick(json, <String>['expires_at', 'expiresAt', 'valid_until']),
        ) ??
        DateTime.now().add(AppConstants.qrRefreshInterval);

    return CustomerCardQr(
      code: Json.text(
        Json.pick(json, <String>['qr_code', 'qrCode', 'code', 'token']),
      ),
      expiresAt: expiresAt,
      customerCardId: Json.textOrNull(
        Json.pick(json, <String>['customer_card_id', 'customerCardId']) ??
            customerCardId,
      ),
      businessName: Json.textOrNull(
        Json.pick(json, <String>['business_name', 'businessName']),
      ),
      cardName: Json.textOrNull(
        Json.pick(json, <String>['card_name', 'cardName', 'name']),
      ),
    );
  }

  final String code;
  final DateTime expiresAt;
  final String? customerCardId;
  final String? businessName;
  final String? cardName;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration get remaining {
    final Duration difference = expiresAt.difference(DateTime.now());
    return difference.isNegative ? Duration.zero : difference;
  }

  bool get shouldRegenerate =>
      remaining < const Duration(seconds: 30) || code.isEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'qr_code': code,
        'expires_at': expiresAt.toIso8601String(),
        if (customerCardId != null) 'customer_card_id': customerCardId,
        if (businessName != null) 'business_name': businessName,
        if (cardName != null) 'card_name': cardName,
      };
}
