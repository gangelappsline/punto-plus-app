import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus_app/core/network/app_failure.dart';
import 'package:punto_plus_app/features/business/domain/demo_qr.dart';

void main() {
  test('demo QR round trips without embedding a token', () {
    const qr = DemoQr(memberId: 'demo-customer', cardId: 'card-origen');
    final parsed = DemoQr.parse(qr.encode());
    expect(parsed.memberId, qr.memberId);
    expect(parsed.cardId, qr.cardId);
    expect(qr.encode(), isNot(contains('token')));
  });

  for (final invalid in [
    '',
    'https://example.com',
    'puntoplus-demo://stamp?v=2&member=a&card=b',
    'puntoplus-demo://stamp?v=1&member=&card=b',
    'puntoplus-demo://stamp?v=1&member=a&card=b&card=c',
    'puntoplus-demo://stamp?v=1&member=a&card=b&extra=1',
    'puntoplus-demo://stamp/path?v=1&member=a&card=b',
    'puntoplus-demo://stamp?v=1&member=a&card=b#fragment',
    'x' * 2049,
  ]) {
    test('rejects malformed, foreign or ambiguous QR (${invalid.length} chars)',
        () {
      expect(() => DemoQr.parse(invalid), throwsA(isA<AppFailure>()));
    });
  }
}
