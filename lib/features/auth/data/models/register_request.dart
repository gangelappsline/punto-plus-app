import 'login_request.dart';

final class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.identifier,
    required this.password,
    required this.type,
  });

  final String fullName;
  final String identifier;
  final String password;
  final IdentifierType type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': fullName.trim(),
        'identifier': identifier.trim(),
        'identifier_type': type.name,
        'password': password,
      };
}
