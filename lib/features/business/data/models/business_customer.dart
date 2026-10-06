import '../../../../core/utils/json.dart';

/// Progreso de un cliente en una tarjeta del negocio.
final class CustomerCardProgress {
  const CustomerCardProgress({
    required this.cardId,
    required this.cardName,
    required this.stampsCount,
    required this.requiredStamps,
  });

  factory CustomerCardProgress.fromJson(Map<String, dynamic> json) =>
      CustomerCardProgress(
        cardId: Json.text(Json.pick(json, <String>['id', 'card_id', 'uuid'])),
        cardName: Json.text(
          Json.pick(json, <String>['name', 'card_name']),
          fallback: 'Tarjeta',
        ),
        stampsCount: Json.integer(
          Json.pick(json, <String>['stamps_count', 'stampsCount']),
        ),
        requiredStamps: Json.integer(
          Json.pick(json, <String>['required_stamps', 'requiredStamps']),
        ),
      );

  final String cardId;
  final String cardName;
  final int stampsCount;
  final int requiredStamps;

  double get progress => requiredStamps <= 0
      ? 0
      : (stampsCount / requiredStamps).clamp(0, 1).toDouble();
}

/// Cliente fiel del negocio con su actividad.
final class BusinessCustomerModel {
  const BusinessCustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.joinedAt,
    this.lastVisitAt,
    this.stampsTotal = 0,
    this.cards = const <CustomerCardProgress>[],
  });

  factory BusinessCustomerModel.fromJson(Map<String, dynamic> json) =>
      BusinessCustomerModel(
        id: Json.text(Json.pick(json, <String>['id', 'uuid', 'user_id'])),
        name: Json.text(
          Json.pick(json, <String>['name', 'display_name', 'customer_name']),
          fallback: 'Cliente',
        ),
        email: Json.textOrNull(json['email']),
        phone: Json.textOrNull(Json.pick(json, <String>['phone', 'mobile'])),
        avatarUrl: Json.textOrNull(
          Json.pick(json, <String>['avatar_url', 'avatarUrl']),
        ),
        joinedAt: Json.dateTimeOrNull(
          Json.pick(json, <String>['joined_at', 'joinedAt', 'created_at']),
        ),
        lastVisitAt: Json.dateTimeOrNull(
          Json.pick(
            json,
            <String>['last_visit_at', 'lastVisitAt', 'last_stamp_at'],
          ),
        ),
        stampsTotal: Json.integer(
          Json.pick(
            json,
            <String>['stamps_total', 'stampsTotal', 'total_stamps'],
          ),
        ),
        cards: Json.maps(
          Json.pick(json, <String>['cards', 'customer_cards']),
        ).map(CustomerCardProgress.fromJson).toList(),
      );

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final DateTime? joinedAt;
  final DateTime? lastVisitAt;
  final int stampsTotal;
  final List<CustomerCardProgress> cards;

  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (joinedAt != null) 'joined_at': joinedAt!.toIso8601String(),
        if (lastVisitAt != null) 'last_visit_at': lastVisitAt!.toIso8601String(),
        'stamps_total': stampsTotal,
        'cards': cards
            .map(
              (CustomerCardProgress card) => <String, dynamic>{
                'id': card.cardId,
                'name': card.cardName,
                'stamps_count': card.stampsCount,
                'required_stamps': card.requiredStamps,
              },
            )
            .toList(),
      };
}
