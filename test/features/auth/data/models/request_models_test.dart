import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/features/auth/data/models/login_request.dart';
import 'package:punto_plus/features/auth/data/models/password_recovery_request.dart';
import 'package:punto_plus/features/auth/data/models/register_request.dart';
import 'package:punto_plus/features/auth/data/models/user_model.dart';

void main() {
  group('LoginRequest', () {
    test('serializa el tipo de identificador seleccionado', () {
      const LoginRequest request = LoginRequest(
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

    test('marca el correo como tal', () {
      const LoginRequest request = LoginRequest(
        identifier: 'persona@punto-plus.com.mx',
        password: 'password',
        type: IdentifierType.email,
      );

      expect(request.toJson()['identifier_type'], 'email');
    });
  });

  test('PasswordRecoveryRequest usa el contrato de la API', () {
    const PasswordRecoveryRequest request = PasswordRecoveryRequest(
      identifier: ' person@site.mx ',
      type: IdentifierType.email,
    );

    expect(request.toJson(), <String, dynamic>{
      'identifier': 'person@site.mx',
      'identifier_type': 'email',
    });
  });

  group('RegisterRequest', () {
    test('envía name + email cuando el registro es por correo', () {
      const RegisterRequest request = RegisterRequest(
        fullName: ' Ana Pérez ',
        identifier: ' ana@ejemplo.com ',
        password: 'secreto-seguro',
        type: IdentifierType.email,
      );

      expect(request.toJson(), <String, dynamic>{
        'name': 'Ana Pérez',
        'email': 'ana@ejemplo.com',
        'password': 'secreto-seguro',
        'password_confirmation': 'secreto-seguro',
        'role': 'customer',
        'accept_terms': true,
      });
      expect(request.toJson().containsKey('phone'), isFalse);
    });

    test('envía name + phone cuando el registro es por celular', () {
      const RegisterRequest request = RegisterRequest(
        fullName: 'Ana Pérez',
        identifier: '+52 55 1234 5678',
        password: 'secreto-seguro',
        type: IdentifierType.phone,
        role: UserRole.business,
        acceptTerms: false,
      );

      final Map<String, dynamic> json = request.toJson();
      expect(json['phone'], '+52 55 1234 5678');
      expect(json.containsKey('email'), isFalse);
      expect(json['role'], 'business');
      expect(json['accept_terms'], isFalse);
    });
  });
}
