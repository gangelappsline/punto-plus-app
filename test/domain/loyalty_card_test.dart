import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus_app/features/demo/data/demo_seed.dart';
import 'package:punto_plus_app/features/wallet/domain/loyalty_card.dart';

void main() {
  test('card calculates progress and preserves extra stamps', () {
    final card = seedCards(DateTime(2026)).first;
    expect(card.remaining, 2);
    expect(card.progress, 0.75);
    expect(card.canRedeem, false);
    final full = card.copyWith(stamps: 10);
    expect(full.canRedeem, true);
    expect(full.remaining, 0);
    expect(full.progress, 1);
    expect(card.stamps, 6);
  });

  test('Freezed card JSON round trip preserves timestamps', () {
    final card = seedCards(DateTime.utc(2026, 10, 13)).first;
    expect(LoyaltyCard.fromJson(card.toJson()), card);
  });
}
