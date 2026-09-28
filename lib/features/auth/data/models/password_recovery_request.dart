import 'login_request.dart';

final class PasswordRecoveryRequest {
  const PasswordRecoveryRequest({
    required this.identifier,
    required this.type,
  });

  final String identifier;
  final IdentifierType type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier.trim(),
        'identifier_type': type.name,
      };
}
