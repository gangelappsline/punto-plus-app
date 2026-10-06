import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('required y name', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('  '), isNotNull);
      expect(Validators.required('ok'), isNull);
      expect(Validators.name('Al'), isNotNull);
      expect(Validators.name('Ana Pérez'), isNull);
    });

    test('email y teléfono', () {
      expect(Validators.email('persona@punto-plus.com.mx'), isNull);
      expect(Validators.email('persona@'), isNotNull);
      expect(Validators.phone('+52 55 1234 5678'), isNull);
      expect(Validators.phone('12345'), isNotNull);
      expect(Validators.emailOrPhone('persona@punto-plus.com.mx'), isNull);
      expect(Validators.emailOrPhone('+52 55 1234 5678'), isNull);
      expect(Validators.emailOrPhone('@@@'), isNotNull);
    });

    test('contraseñas y OTP', () {
      expect(Validators.password('corta'), isNotNull);
      expect(Validators.password('secreto-seguro'), isNull);
      expect(
        Validators.passwordConfirmation('secreto-seguro', 'secreto-seguro'),
        isNull,
      );
      expect(
        Validators.passwordConfirmation('otra', 'secreto-seguro'),
        isNotNull,
      );
      expect(Validators.otp('12345'), isNotNull);
      expect(Validators.otp('123456'), isNull);
    });

    test('rangos y términos', () {
      final DateTime start = DateTime(2026, 1, 1);
      expect(Validators.dateRange(start, start.add(const Duration(days: 1))), isNull);
      expect(Validators.dateRange(start.add(const Duration(days: 2)), start), isNotNull);
      expect(Validators.accepted(false), isNotNull);
      expect(Validators.accepted(true), isNull);
      expect(Validators.looksLikePhone('+52 55 1234 5678'), isTrue);
      expect(Validators.isEmail('persona@punto-plus.com.mx'), isTrue);
    });
  });
}
