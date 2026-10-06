import 'package:flutter/material.dart';

/// Colores de marca y paleta clara de referencia.
///
/// Para interfaces que deben adaptarse al tema activo usa
/// `context.palette` (`AppPalette`), que contiene estos mismos conceptos
/// resueltos para claro y oscuro. Las constantes de esta clase se reservan
/// para elementos de marca que no cambian entre temas (degradados, sellos,
/// ilustraciones).
abstract final class AppColors {
  // --- Marca ---------------------------------------------------------------
  static const Color navy = Color(0xFF003F60);
  static const Color teal = Color(0xFF007D8D);
  static const Color cyan = Color(0xFF1AA5B7);
  static const Color orange = Color(0xFFFFA15E);
  static const Color lightBlue = Color(0xFFD6EAFF);

  /// Color semilla de Material 3 (degradado principal de la app).
  static const Color brandGradientStart = teal;
  static const Color brandGradientEnd = cyan;
  static const Color accentGradientStart = orange;
  static const Color accentGradientEnd = Color(0xFFFFC48F);

  // --- Paleta clara (valores por defecto) ---------------------------------
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color field = Color(0xFFF0F2F4);
  static const Color segmented = Color(0xFFE9ECEF);
  static const Color text = Color(0xFF24282B);
  static const Color textMuted = Color(0xFF4F585D);
  static const Color divider = Color(0xFFDDE2E5);
  static const Color error = Color(0xFFC33B43);
  static const Color success = Color(0xFF1B9C6B);
  static const Color warning = Color(0xFFD98A00);
  static const Color stampPending = Color(0xFFE3E7EA);
  static const Color onBrand = Color(0xFFFFFFFF);

  /// Degradado de marca reutilizable.
  static const LinearGradient brandGradient = LinearGradient(
    colors: <Color>[brandGradientStart, brandGradientEnd],
  );

  /// Degradado cálido para recompensas y premios.
  static const LinearGradient rewardGradient = LinearGradient(
    colors: <Color>[accentGradientStart, accentGradientEnd],
  );
}
