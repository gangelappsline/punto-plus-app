/// Tipo de identificador usado en el inicio de sesión.
enum IdentifierType { email, phone }

final class LoginRequest {
  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.type,
    this.remember = true,
  });

  final String identifier;
  final String password;
  final IdentifierType type;
  final bool remember;

  Map<String, dynamic> toJson() => <String, dynamic>{
        type == IdentifierType.email ? 'email' : 'phone': identifier.trim(),
        'password': password,
        'remember': remember,
      };
}
