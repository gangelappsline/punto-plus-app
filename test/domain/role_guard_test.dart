import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus_app/app/providers.dart';
import 'package:punto_plus_app/app/router.dart';
import 'package:punto_plus_app/core/network/app_failure.dart';
import 'package:punto_plus_app/features/auth/domain/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const customer =
      Session(userId: 'customer', name: 'Alex', role: UserRole.customer);
  const business =
      Session(userId: 'owner', name: 'Café', role: UserRole.business);

  test('deep links cannot bypass session and role guards', () {
    expect(sessionRedirect(null, '/business/scan'), '/welcome');
    expect(sessionRedirect(customer, '/business/card'), '/wallet');
    expect(sessionRedirect(business, '/cards/card-origen'), '/business');
    expect(sessionRedirect(customer, '/cards/card-origen'), isNull);
    expect(sessionRedirect(business, '/settings'), isNull);
  });

  test('use cases reject offline and unauthorized mutations', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      preferencesProvider.overrideWithValue(prefs),
      offlineProvider.overrideWithValue(true),
    ]);
    addTearDown(container.dispose);
    final actions = container.read(actionsProvider);
    await expectLater(
        actions.redeem('card-miga', '1'), throwsA(isA<AppFailure>()));
    container.read(sessionProvider.notifier).enterDemo(UserRole.customer);
    await expectLater(
        actions.redeem('card-miga', '1'), throwsA(isA<AppFailure>()));
    await expectLater(actions.purchase('qr', '1'), throwsA(isA<AppFailure>()));
    final cards = await container.read(cardsProvider.future);
    expect(cards.cards.firstWhere((card) => card.id == 'card-miga').stamps, 5);
  });
}
