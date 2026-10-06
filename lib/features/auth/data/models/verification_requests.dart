/// Solicitud del código de verificación (OTP) de 6 dígitos.
final class VerifyCodeRequest {
  const VerifyCodeRequest({required this.identifier, required this.code});

  final String identifier;
  final String code;

  Map<String, dynamic> toJson() => <String, dynamic>{
        _identifierKey: identifier.trim(),
        'code': code.trim(),
      };

  String get _identifierKey => identifier.contains('@') ? 'email' : 'phone';
}

/// Reenvío del código de verificación.
final class ResendCodeRequest {
  const ResendCodeRequest({required this.identifier});

  final String identifier;

  Map<String, dynamic> toJson() => <String, dynamic>{
        identifier.contains('@') ? 'email' : 'phone': identifier.trim(),
      };
}

/// Restablecimiento de contraseña con el código recibido por correo.
final class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.password,
  });

  final String email;
  final String code;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email.trim(),
        'code': code.trim(),
        'password': password,
        'password_confirmation': password,
      };
}
