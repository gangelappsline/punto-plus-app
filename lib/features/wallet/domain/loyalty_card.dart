import 'package:freezed_annotation/freezed_annotation.dart';

part 'loyalty_card.freezed.dart';
part 'loyalty_card.g.dart';

@freezed
class LoyaltyCard with _$LoyaltyCard {
  const LoyaltyCard._();
  const factory LoyaltyCard({
    required String id,
    required String businessId,
    required String businessName,
    required String category,
    required String reward,
    required int stamps,
    required int target,
    required int color,
    required String symbol,
    required DateTime updatedAt,
    @Default('') String logoPath,
    @Default('') String backgroundPath,
    @Default('') String stampPath,
    @Default(0) int redeemed,
  }) = _LoyaltyCard;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardFromJson(json);

  bool get canRedeem => stamps >= target && target > 0;
  int get remaining => (target - stamps).clamp(0, target).toInt();
  double get progress =>
      target > 0 ? (stamps / target).clamp(0, 1).toDouble() : 0;
}

class CardSnapshot {
  const CardSnapshot(
      {required this.cards, required this.savedAt, this.fromCache = false});
  final List<LoyaltyCard> cards;
  final DateTime savedAt;
  final bool fromCache;
}
