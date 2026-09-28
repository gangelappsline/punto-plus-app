import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/features/auth/data/models/login_request.dart';
import 'package:punto_plus/features/auth/data/models/password_recovery_request.dart';
import 'package:punto_plus/features/auth/data/models/register_request.dart';

void main() {
  test('LoginRequest serializes the selected identifier type', () {
    const request = LoginRequest(
      identifier: ' +52 55 1234 5678 ',
      password: 'password',
      type: IdentifierType.phone,
    );

    expect(request.toJson(), <String, dynamic>{
      'identifier': '+52 55 1234 5678',
      'identifier_type': 'phone',
      'password': 'password',
    });
  });

  test('PasswordRecoveryRequest uses the API contract', () {
    const request = PasswordRecoveryRequest(
      identifier: ' person@site.mx ',
      type: IdentifierType.email,
    );

    expect(request.toJson(), <String, dynamic>{
      'identifier': 'person@site.mx',
      'identifier_type': 'email',
    });
  });

  test('RegisterRequest trims user-provided text', () {
    const request = RegisterRequest(
      fullName: ' Ana Pérez ',
      identifier: ' ana@ejemplo.com ',
      password: 'password',
      type: IdentifierType.email,
    );

    expect(request.toJson()['name'], 'Ana Pérez');
    expect(request.toJson()['identifier'], 'ana@ejemplo.com');
  });
}
