import 'package:flutter/material.dart';

const ink = Color(0xFF183D35);
const lime = Color(0xFFD9EF91);
const canvas = Color(0xFFF8F8F2);
const muted = Color(0xFF6E7D75);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: ink).copyWith(
    primary: ink,
    onPrimary: Colors.white,
    secondary: lime,
    onSecondary: ink,
    surface: canvas,
    onSurface: ink,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: canvas,
    fontFamily: 'sans-serif',
    appBarTheme: const AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 36,
          height: 1.15,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
          color: ink),
      headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.2,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: ink),
      titleLarge:
          TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: ink),
      titleMedium:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: ink),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
      minimumSize: const Size(48, 54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: const Size(48, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      side: const BorderSide(color: Color(0xFFD4DDD4)),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE0E5DC))),
      contentPadding: const EdgeInsets.all(18),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: canvas,
      indicatorColor: lime,
      labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ),
    dividerTheme:
        const DividerThemeData(color: Color(0xFFE2E7DC), thickness: 1),
  );
}
