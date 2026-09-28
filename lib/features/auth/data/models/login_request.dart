enum IdentifierType { email, phone }

final class LoginRequest {
  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.type,
  });

  final String identifier;
  final String password;
  final IdentifierType type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier.trim(),
        'identifier_type': type.name,
        'password': password,
      };
}
