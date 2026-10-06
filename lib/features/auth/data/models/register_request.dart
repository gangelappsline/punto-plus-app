import 'login_request.dart';
import 'user_model.dart';

final class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.identifier,
    required this.password,
    required this.type,
    this.role = UserRole.customer,
    this.acceptTerms = true,
  });

  final String fullName;
  final String identifier;
  final String password;
  final IdentifierType type;
  final UserRole role;
  final bool acceptTerms;

  bool get isEmail => type == IdentifierType.email;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': fullName.trim(),
        if (isEmail) 'email': identifier.trim() else 'phone': identifier.trim(),
        'password': password,
        'password_confirmation': password,
        'role': role.name,
        'accept_terms': acceptTerms,
      };
}
