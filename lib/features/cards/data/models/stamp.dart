import '../../../../core/utils/json.dart';

/// Sello registrado en una tarjeta de cliente.
final class StampModel {
  const StampModel({
    required this.id,
    required this.createdAt,
    this.customerCardId,
    this.businessId,
    this.businessName,
    this.cardName,
    this.customerName,
    this.note,
  });

  factory StampModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> business = Json.map(
      Json.pick(json, <String>['business', 'business_info']),
    );
    final Map<String, dynamic> card = Json.map(
      Json.pick(json, <String>['loyalty_card', 'card', 'customer_card']),
    );
    final Map<String, dynamic> customer = Json.map(
      Json.pick(json, <String>['customer', 'user', 'client']),
    );

    return StampModel(
      id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
      createdAt: Json.dateTimeOrNull(
            Json.pick(json, <String>['created_at', 'createdAt', 'stamped_at']),
          ) ??
          DateTime.now(),
      customerCardId: Json.textOrNull(
        Json.pick(json, <String>['customer_card_id', 'customerCardId']),
      ),
      businessId: Json.textOrNull(
        Json.pick(json, <String>['business_id', 'businessId']) ?? business['id'],
      ),
      businessName: Json.textOrNull(
        Json.pick(json, <String>['business_name', 'businessName']) ??
            business['name'],
      ),
      cardName: Json.textOrNull(
        Json.pick(json, <String>['card_name', 'cardName']) ?? card['name'],
      ),
      customerName: Json.textOrNull(
        Json.pick(json, <String>['customer_name', 'customerName']) ??
            customer['display_name'] ??
            customer['name'],
      ),
      note: Json.textOrNull(json['note']),
    );
  }

  final String id;
  final DateTime createdAt;
  final String? customerCardId;
  final String? businessId;
  final String? businessName;
  final String? cardName;
  final String? customerName;
  final String? note;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt.toIso8601String(),
        if (customerCardId != null) 'customer_card_id': customerCardId,
        if (businessId != null) 'business_id': businessId,
        if (businessName != null) 'business_name': businessName,
        if (cardName != null) 'card_name': cardName,
        if (customerName != null) 'customer_name': customerName,
        if (note != null) 'note': note,
      };
}
