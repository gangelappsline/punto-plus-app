import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Paleta dependiente del tema activo.
///
/// Se registra como `ThemeExtension`, de modo que cualquier widget puede
/// resolver colores coherentes en claro y oscuro con `context.palette`.
@immutable
final class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.field,
    required this.segmented,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.divider,
    required this.brand,
    required this.brandStrong,
    required this.brandSoft,
    required this.brandContrast,
    required this.accent,
    required this.success,
    required this.warning,
    required this.error,
    required this.stampPending,
    required this.stampEarned,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.overlay,
    required this.shadow,
    required this.onBrand,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color field;
  final Color segmented;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color divider;

  /// Color de marca principal (teal en claro, teal luminoso en oscuro).
  final Color brand;

  /// Variante oscura/profunda de la marca (navy).
  final Color brandStrong;

  /// Fondo suave de marca (chips, contenedores destacados).
  final Color brandSoft;

  /// Texto/icono que se dibuja sobre [brandSoft].
  final Color brandContrast;
  final Color accent;
  final Color success;
  final Color warning;
  final Color error;
  final Color stampPending;
  final Color stampEarned;
  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color overlay;
  final Color shadow;
  final Color onBrand;

  static const AppPalette light = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceAlt: Color(0xFFF1F4F7),
    field: AppColors.field,
    segmented: AppColors.segmented,
    text: AppColors.text,
    textMuted: AppColors.textMuted,
    textFaint: Color(0xFF7A8489),
    divider: AppColors.divider,
    brand: AppColors.teal,
    brandStrong: AppColors.navy,
    brandSoft: AppColors.lightBlue,
    brandContrast: AppColors.navy,
    accent: AppColors.orange,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    stampPending: AppColors.stampPending,
    stampEarned: AppColors.cyan,
    skeletonBase: Color(0xFFE6EAEE),
    skeletonHighlight: Color(0xFFF4F7F9),
    overlay: Color(0x59001E2D),
    shadow: Color(0x14003F60),
    onBrand: AppColors.onBrand,
  );

  static const AppPalette dark = AppPalette(
    background: Color(0xFF061418),
    surface: Color(0xFF0C2028),
    surfaceAlt: Color(0xFF102B34),
    field: Color(0xFF143039),
    segmented: Color(0xFF17343D),
    text: Color(0xFFEAF2F4),
    textMuted: Color(0xFFA9BCC2),
    textFaint: Color(0xFF7E939A),
    divider: Color(0xFF1E3D47),
    brand: Color(0xFF35C2CE),
    brandStrong: Color(0xFF0B3A4C),
    brandSoft: Color(0xFF16414F),
    brandContrast: Color(0xFFBFE6F2),
    accent: Color(0xFFFFB77E),
    success: Color(0xFF5FD1A0),
    warning: Color(0xFFF5C05A),
    error: Color(0xFFFF8A80),
    stampPending: Color(0xFF17343D),
    stampEarned: Color(0xFF6FD9E6),
    skeletonBase: Color(0xFF142A33),
    skeletonHighlight: Color(0xFF1D3944),
    overlay: Color(0x99203038),
    shadow: Color(0x33000000),
    onBrand: Colors.white,
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? light;

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? field,
    Color? segmented,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? divider,
    Color? brand,
    Color? brandStrong,
    Color? brandSoft,
    Color? brandContrast,
    Color? accent,
    Color? success,
    Color? warning,
    Color? error,
    Color? stampPending,
    Color? stampEarned,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? overlay,
    Color? shadow,
    Color? onBrand,
  }) =>
      AppPalette(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        surfaceAlt: surfaceAlt ?? this.surfaceAlt,
        field: field ?? this.field,
        segmented: segmented ?? this.segmented,
        text: text ?? this.text,
        textMuted: textMuted ?? this.textMuted,
        textFaint: textFaint ?? this.textFaint,
        divider: divider ?? this.divider,
        brand: brand ?? this.brand,
        brandStrong: brandStrong ?? this.brandStrong,
        brandSoft: brandSoft ?? this.brandSoft,
        brandContrast: brandContrast ?? this.brandContrast,
        accent: accent ?? this.accent,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        error: error ?? this.error,
        stampPending: stampPending ?? this.stampPending,
        stampEarned: stampEarned ?? this.stampEarned,
        skeletonBase: skeletonBase ?? this.skeletonBase,
        skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
        overlay: overlay ?? this.overlay,
        shadow: shadow ?? this.shadow,
        onBrand: onBrand ?? this.onBrand,
      );

  @override
  AppPalette lerp(covariant ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      field: Color.lerp(field, other.field, t)!,
      segmented: Color.lerp(segmented, other.segmented, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandStrong: Color.lerp(brandStrong, other.brandStrong, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      brandContrast: Color.lerp(brandContrast, other.brandContrast, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      stampPending: Color.lerp(stampPending, other.stampPending, t)!,
      stampEarned: Color.lerp(stampEarned, other.stampEarned, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight:
          Color.lerp(skeletonHighlight, other.skeletonHighlight, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
    );
  }
}
