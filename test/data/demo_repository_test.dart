import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus_app/core/network/app_failure.dart';
import 'package:punto_plus_app/features/business/domain/demo_qr.dart';
import 'package:punto_plus_app/features/business/domain/promotion.dart';
import 'package:punto_plus_app/features/demo/data/demo_repository.dart';
import 'package:punto_plus_app/features/demo/data/demo_seed.dart';
import 'package:punto_plus_app/features/wallet/data/card_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late DemoRepository repository;
  final now = DateTime.utc(2026, 10, 13);
  final qr =
      const DemoQr(memberId: demoMemberId, cardId: 'card-origen').encode();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = DemoRepository(prefs, CardCache(prefs), clock: () => now);
  });

  test('concurrent duplicate purchases apply once and persist after restart',
      () async {
    await Future.wait(List.generate(
        3,
        (_) => repository.registerPurchase(
              businessId: demoBusinessId,
              qr: qr,
              operationId: 'receipt-1',
            )));
    final restarted = DemoRepository(prefs, CardCache(prefs), clock: () => now);
    final snapshot = await restarted.cards(demoMemberId, offline: false);
    expect(snapshot.cards.first.stamps, 7);
    await restarted.registerPurchase(
        businessId: demoBusinessId, qr: qr, operationId: 'receipt-1');
    expect(
        (await restarted.cards(demoMemberId, offline: false))
            .cards
            .first
            .stamps,
        7);
  });

  test(
      'purchase then redeem updates the customer card, duplicate canje is safe',
      () async {
    await repository.registerPurchase(
        businessId: demoBusinessId, qr: qr, operationId: '1');
    await repository.registerPurchase(
        businessId: demoBusinessId, qr: qr, operationId: '2');
    await repository.redeem(demoMemberId, 'card-origen', 'redeem-1');
    await repository.redeem(demoMemberId, 'card-origen', 'redeem-1');
    final card =
        (await repository.cards(demoMemberId, offline: false)).cards.first;
    expect(card.stamps, 0);
    expect(card.redeemed, 1);
    await expectLater(
        repository.redeem(demoMemberId, 'card-origen', 'redeem-2'),
        throwsA(isA<AppFailure>()));
  });

  test('failed mutation does not block later operations', () async {
    await expectLater(
        repository.registerPurchase(
            businessId: 'other-business', qr: qr, operationId: 'bad'),
        throwsA(isA<AppFailure>()));
    await repository.registerPurchase(
        businessId: demoBusinessId, qr: qr, operationId: 'good');
    expect(
        (await repository.cards(demoMemberId, offline: false))
            .cards
            .first
            .stamps,
        7);
  });

  test('cannot grant a stamp for another business or an unknown customer',
      () async {
    for (final value in [
      const DemoQr(memberId: demoMemberId, cardId: 'card-miga').encode(),
      const DemoQr(memberId: 'stranger', cardId: 'card-origen').encode(),
    ]) {
      await expectLater(
          repository.registerPurchase(
              businessId: demoBusinessId, qr: value, operationId: '1'),
          throwsA(isA<AppFailure>()));
    }
  });

  test('design changes cannot overwrite balances', () async {
    final original =
        (await repository.cards(demoMemberId, offline: false)).cards.first;
    await repository.saveCard(demoBusinessId,
        original.copyWith(stamps: 999, redeemed: 99, reward: 'Nuevo café'));
    final card =
        (await repository.cards(demoMemberId, offline: false)).cards.first;
    expect(card.stamps, 6);
    expect(card.redeemed, 0);
    expect(card.reward, 'Nuevo café');
    await expectLater(
        repository.saveCard(demoBusinessId, card.copyWith(target: 0)),
        throwsA(isA<AppFailure>()));
  });

  test('promotions validate ownership and expiry, publish and delete',
      () async {
    final promotion = Promotion(
        id: '1',
        businessId: demoBusinessId,
        title: 'Doble alegría',
        description: 'Promoción ficticia de prueba.',
        expiresAt: now.add(const Duration(days: 7)));
    await expectLater(repository.savePromotion('other', promotion),
        throwsA(isA<AppFailure>()));
    await expectLater(
        repository.savePromotion(
            demoBusinessId, promotion.copyWith(expiresAt: now)),
        throwsA(isA<AppFailure>()));
    await repository.savePromotion(demoBusinessId, promotion);
    await repository.savePromotion(demoBusinessId, promotion);
    expect(await repository.promotions(), [promotion]);
    await repository.deletePromotion(demoBusinessId, '1');
    expect(await repository.promotions(), isEmpty);
  });

  test('offline card snapshot is marked and mutations refresh cache', () async {
    await repository.cards(demoMemberId, offline: false);
    await repository.registerPurchase(
        businessId: demoBusinessId, qr: qr, operationId: '1');
    final offline = await repository.cards(demoMemberId, offline: true);
    expect(offline.fromCache, true);
    expect(offline.savedAt, now);
    expect(offline.cards.first.stamps, 7);
  });

  test('reset and corrupt database recover fixtures', () async {
    await repository.registerPurchase(
        businessId: demoBusinessId, qr: qr, operationId: '1');
    await repository.reset();
    expect(
        (await repository.cards(demoMemberId, offline: false))
            .cards
            .first
            .stamps,
        6);
    await prefs.setString(DemoRepository.storageKey, '{bad json');
    final restarted = DemoRepository(prefs, CardCache(prefs), clock: () => now);
    expect(
        (await restarted.cards(demoMemberId, offline: false)).cards.length, 3);
  });
}
