abstract final class Validators {
  static String? required(String? value, {String message = 'Campo obligatorio'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? emailOrPhone(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;

    final input = value!.trim();
    final isEmail = RegExp(
      r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
    ).hasMatch(input);
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final isPhone = digits.length >= 10 && digits.length <= 15;

    if (!isEmail && !isPhone) return 'Ingresa un correo o celular válido';
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Usa al menos 8 caracteres';
    return null;
  }

  static bool looksLikePhone(String value) =>
      RegExp(r'^\+?[\d\s()-]+$').hasMatch(value.trim());
}
