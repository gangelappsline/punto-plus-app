import '../../../../core/utils/json.dart';

/// Invitación enviada por el usuario.
final class ReferralInvite {
  const ReferralInvite({
    required this.id,
    this.name,
    this.status = 'pending',
    this.createdAt,
    this.completedAt,
  });

  factory ReferralInvite.fromJson(Map<String, dynamic> json) => ReferralInvite(
        id: Json.text(Json.pick(json, <String>['id', 'uuid'])),
        name: Json.textOrNull(
          Json.pick(json, <String>['name', 'display_name', 'invited_name']),
        ),
        status: Json.text(
          Json.pick(json, <String>['status', 'state']),
          fallback: 'pending',
        ),
        createdAt: Json.dateTimeOrNull(
          Json.pick(json, <String>['created_at', 'createdAt', 'invited_at']),
        ),
        completedAt: Json.dateTimeOrNull(
          Json.pick(json, <String>['completed_at', 'completedAt']),
        ),
      );

  final String id;
  final String? name;
  final String status;
  final DateTime? createdAt;
  final DateTime? completedAt;

  bool get isCompleted =>
      completedAt != null || status.toLowerCase() == 'completed';
}

/// Resumen del programa de referidos del cliente.
final class ReferralSummary {
  const ReferralSummary({
    required this.code,
    this.invitedCount = 0,
    this.completedCount = 0,
    this.pendingCount = 0,
    this.pointsEarned = 0,
    this.invites = const <ReferralInvite>[],
  });

  factory ReferralSummary.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Json.mapOrNull(json['data']) ?? json;
    final List<ReferralInvite> invites = Json.maps(
      Json.pick(data, <String>['invites', 'referrals', 'friends']),
    ).map(ReferralInvite.fromJson).toList();
    final int completed = Json.integer(
      Json.pick(data, <String>['completed_count', 'completedCount']),
      fallback: invites.where((ReferralInvite item) => item.isCompleted).length,
    );
    final int invited = Json.integer(
      Json.pick(data, <String>['invited_count', 'invitedCount', 'total']),
      fallback: invites.length,
    );

    return ReferralSummary(
      code: Json.text(
        Json.pick(data, <String>['code', 'referral_code', 'referralCode']),
      ),
      invitedCount: invited,
      completedCount: completed,
      pendingCount: Json.integer(
        Json.pick(data, <String>['pending_count', 'pendingCount']),
        fallback: invited - completed,
      ),
      pointsEarned: Json.integer(
        Json.pick(data, <String>['points_earned', 'pointsEarned', 'points']),
      ),
      invites: invites,
    );
  }

  final String code;
  final int invitedCount;
  final int completedCount;
  final int pendingCount;
  final int pointsEarned;
  final List<ReferralInvite> invites;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'invited_count': invitedCount,
        'completed_count': completedCount,
        'pending_count': pendingCount,
        'points_earned': pointsEarned,
        'invites': invites
            .map(
              (ReferralInvite invite) => <String, dynamic>{
                'id': invite.id,
                if (invite.name != null) 'name': invite.name,
                'status': invite.status,
                if (invite.createdAt != null)
                  'created_at': invite.createdAt!.toIso8601String(),
                if (invite.completedAt != null)
                  'completed_at': invite.completedAt!.toIso8601String(),
              },
            )
            .toList(),
      };
}
