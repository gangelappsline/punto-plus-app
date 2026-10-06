import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';
import 'app_spacing.dart';

/// Tema Material 3 de Punto+ (claro y oscuro).
abstract final class AppTheme {
  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: brightness,
    ).copyWith(
      primary: palette.brand,
      onPrimary: palette.onBrand,
      secondary: palette.accent,
      surface: palette.surface,
      onSurface: palette.text,
      error: palette.error,
      outline: palette.divider,
      surfaceContainerHighest: palette.field,
    );

    final TextTheme baseTextTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        height: 1.15,
        color: palette.text,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        height: 1.15,
        color: palette.text,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: palette.text,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: palette.text,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.25,
        color: palette.text,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        height: 1.25,
        color: palette.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        height: 1.35,
        color: palette.text,
      ),
      bodyMedium: TextStyle(
        fontSize: 13.5,
        height: 1.35,
        color: palette.textMuted,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.3,
        color: palette.textMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: palette.text,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: palette.textMuted,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: palette.textMuted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'NunitoSans',
      scaffoldBackgroundColor: palette.background,
      colorScheme: scheme,
      textTheme: baseTextTheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: palette.shadow,
        centerTitle: false,
        titleTextStyle: baseTextTheme.titleLarge,
        iconTheme: IconThemeData(color: palette.text, size: 22),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: palette.brand,
        unselectedItemColor: palette.textFaint,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.brandSoft,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: AppSizes.bottomNavHeight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? baseTextTheme.labelMedium!.copyWith(color: palette.brand)
              : baseTextTheme.labelMedium,
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => IconThemeData(
            size: 23,
            color: states.contains(WidgetState.selected)
                ? palette.brand
                : palette.textFaint,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.field,
        hintStyle: TextStyle(
          color: palette.textFaint,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: TextStyle(color: palette.textMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: palette.brand, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: palette.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: palette.error, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 13,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allLg),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allXl),
        titleTextStyle: baseTextTheme.titleLarge,
        contentTextStyle: baseTextTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: palette.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        dragHandleColor: palette.divider,
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.brandStrong,
        contentTextStyle: TextStyle(
          color: palette.onBrand,
          fontWeight: FontWeight.w700,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceAlt,
        selectedColor: palette.brandSoft,
        side: BorderSide(color: palette.divider),
        labelStyle: baseTextTheme.labelMedium!.copyWith(color: palette.text),
        secondaryLabelStyle:
            baseTextTheme.labelMedium!.copyWith(color: palette.brandContrast),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allPill),
        showCheckmark: false,
      ),
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textMuted,
        titleTextStyle: baseTextTheme.titleSmall,
        subtitleTextStyle: baseTextTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? palette.onBrand
              : palette.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? palette.brand
              : palette.segmented,
        ),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.brand,
        linearTrackColor: palette.segmented,
        circularTrackColor: palette.segmented,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: palette.brand,
        unselectedLabelColor: palette.textMuted,
        indicatorColor: palette.brand,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: palette.divider,
        labelStyle: baseTextTheme.labelLarge,
        unselectedLabelStyle: baseTextTheme.labelLarge,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.brandStrong,
          borderRadius: AppRadius.allSm,
        ),
        textStyle: TextStyle(color: palette.onBrand, fontSize: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.brand,
          foregroundColor: palette.onBrand,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          textStyle: baseTextTheme.labelLarge!.copyWith(
            color: palette.onBrand,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.allPill),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.text,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          side: BorderSide(color: palette.divider),
          textStyle: baseTextTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.allPill),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.brand,
          textStyle: baseTextTheme.labelLarge!.copyWith(color: palette.brand),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.brand,
        foregroundColor: palette.onBrand,
        elevation: 2,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.allLg),
      ),
    );
  }
}
