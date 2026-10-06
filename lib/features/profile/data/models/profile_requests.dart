/// Actualización de los datos básicos del perfil.
final class UpdateProfileRequest {
  const UpdateProfileRequest({required this.name, this.email, this.phone});

  final String name;
  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name.trim(),
        if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      };
}

/// Cambio de contraseña desde el perfil.
final class ChangePasswordRequest {
  const ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
  });

  final String currentPassword;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': password,
      };
}
