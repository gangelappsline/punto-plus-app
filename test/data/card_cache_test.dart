import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus_app/features/demo/data/demo_seed.dart';
import 'package:punto_plus_app/features/wallet/data/card_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('cache is isolated by user and removable on logout', () async {
    SharedPreferences.setMockInitialValues({});
    final cache = CardCache(await SharedPreferences.getInstance());
    final now = DateTime.utc(2026);
    await cache.write('user-a', seedCards(now), now);
    expect(await cache.read('user-b'), isNull);
    final snapshot = await cache.read('user-a');
    expect(snapshot!.fromCache, true);
    expect(snapshot.cards.length, 3);
    await cache.clear('user-a');
    expect(await cache.read('user-a'), isNull);
  });

  test('corrupt cache is removed without breaking startup', () async {
    SharedPreferences.setMockInitialValues({'cards.v1.demo': '{broken'});
    final prefs = await SharedPreferences.getInstance();
    expect(await CardCache(prefs).read('demo'), isNull);
    expect(prefs.containsKey('cards.v1.demo'), false);
  });
}
