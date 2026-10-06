/// Validaciones de formularios reutilizables.
abstract final class Validators {
  static final RegExp _emailRegExp = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
  );

  static String? required(String? value, {String message = 'Campo obligatorio'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? name(String? value, {String? message}) {
    final String? requiredError =
        required(value, message: message ?? 'Campo obligatorio');
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 3) {
      return message ?? 'Escribe tu nombre completo';
    }
    if (!value.trim().contains(' ')) {
      return message ?? 'Escribe tu nombre completo';
    }
    return null;
  }

  static String? email(String? value, {String? message}) {
    final String? requiredError =
        required(value, message: message ?? 'Campo obligatorio');
    if (requiredError != null) return requiredError;
    if (!_emailRegExp.hasMatch(value!.trim())) {
      return message ?? 'Correo no válido';
    }
    return null;
  }

  static String? phone(String? value, {String? message}) {
    final String? requiredError =
        required(value, message: message ?? 'Campo obligatorio');
    if (requiredError != null) return requiredError;
    final String digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return message ?? 'Celular no válido';
    }
    return null;
  }

  static String? emailOrPhone(String? value, {String? message}) {
    final String? requiredError =
        required(value, message: message ?? 'Campo obligatorio');
    if (requiredError != null) return requiredError;

    final String input = value!.trim();
    final String digits = input.replaceAll(RegExp(r'\D'), '');
    final bool isEmail = _emailRegExp.hasMatch(input);
    final bool isPhone = digits.length >= 10 && digits.length <= 15;

    if (!isEmail && !isPhone) {
      return message ?? 'Ingresa un correo o celular válido';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 8, String? message}) {
    final String? requiredError =
        required(value, message: message ?? 'Campo obligatorio');
    if (requiredError != null) return requiredError;
    if (value!.length < minLength) {
      return message ?? 'Usa al menos $minLength caracteres';
    }
    return null;
  }

  static String? passwordConfirmation(String? value, String password) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (value != password) return 'Las contraseñas no coinciden';
    return null;
  }

  static String? currentPassword(String? value) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;
    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;
    final String digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length != length) return 'Ingresa los $length dígitos';
    return null;
  }

  static String? numeric(
    String? value, {
    int? min,
    int? max,
    String? message,
  }) {
    final String? requiredError =
        required(value, message: message ?? 'Campo obligatorio');
    if (requiredError != null) return requiredError;
    final int? parsed = int.tryParse(value!.trim());
    if (parsed == null) return message ?? 'Ingresa solo números';
    if (min != null && max != null && (parsed < min || parsed > max)) {
      return message ?? 'Ingresa un valor entre $min y $max';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? message}) {
    if (value != null && value.length > max) {
      return message ?? 'Máximo $max caracteres';
    }
    return null;
  }

  static String? optionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return email(value);
  }

  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return phone(value);
  }

  static String? dateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return null;
    if (end.isBefore(start)) {
      return 'La fecha final debe ser posterior a la inicial';
    }
    return null;
  }

  static String? accepted(bool? value) {
    if (value != true) {
      return 'Debes aceptar los términos y la política de privacidad';
    }
    return null;
  }

  static bool looksLikePhone(String value) =>
      RegExp(r'^\+?[\d\s()-]+$').hasMatch(value.trim());

  static bool isEmail(String value) => _emailRegExp.hasMatch(value.trim());
}
