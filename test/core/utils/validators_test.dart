import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/utils/validators.dart';

void main() {
  group('Validators.emailOrPhone', () {
    test('accepts email and Mexican phone values', () {
      expect(Validators.emailOrPhone('persona@ejemplo.com'), isNull);
      expect(Validators.emailOrPhone('+52 55 1234 5678'), isNull);
    });

    test('rejects invalid and empty values', () {
      expect(Validators.emailOrPhone(''), isNotNull);
      expect(Validators.emailOrPhone('persona@'), isNotNull);
      expect(Validators.emailOrPhone('123'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('requires at least eight characters', () {
      expect(Validators.password('1234567'), isNotNull);
      expect(Validators.password('12345678'), isNull);
    });
  });
}
