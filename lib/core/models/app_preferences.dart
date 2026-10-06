import 'package:flutter/material.dart';

/// Preferencias locales del usuario (tema, idioma, avisos y ubicación).
@immutable
final class AppPreferences {
  const AppPreferences({
    this.themeMode = ThemeMode.system,
    this.languageCode,
    this.notifyStamps = true,
    this.notifyRewards = true,
    this.notifyPromotions = true,
    this.notifyGeneral = true,
    this.useDeviceLocation = false,
    this.manualArea,
    this.onboardingCompleted = false,
    this.referralCode,
  });

  factory AppPreferences.fromJson(Map<String, dynamic> json) => AppPreferences(
        themeMode: _themeModeFromName(json['theme_mode']?.toString()),
        languageCode: json['language_code']?.toString(),
        notifyStamps: json['notify_stamps'] as bool? ?? true,
        notifyRewards: json['notify_rewards'] as bool? ?? true,
        notifyPromotions: json['notify_promotions'] as bool? ?? true,
        notifyGeneral: json['notify_general'] as bool? ?? true,
        useDeviceLocation: json['use_device_location'] as bool? ?? false,
        manualArea: json['manual_area']?.toString(),
        onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
        referralCode: json['referral_code']?.toString(),
      );

  final ThemeMode themeMode;

  /// `es`, `en` o `null` para seguir el idioma del sistema.
  final String? languageCode;
  final bool notifyStamps;
  final bool notifyRewards;
  final bool notifyPromotions;
  final bool notifyGeneral;
  final bool useDeviceLocation;
  final String? manualArea;
  final bool onboardingCompleted;
  final String? referralCode;

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);

  AppPreferences copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    bool clearLanguage = false,
    bool? notifyStamps,
    bool? notifyRewards,
    bool? notifyPromotions,
    bool? notifyGeneral,
    bool? useDeviceLocation,
    String? manualArea,
    bool? onboardingCompleted,
    String? referralCode,
  }) =>
      AppPreferences(
        themeMode: themeMode ?? this.themeMode,
        languageCode: clearLanguage ? null : (languageCode ?? this.languageCode),
        notifyStamps: notifyStamps ?? this.notifyStamps,
        notifyRewards: notifyRewards ?? this.notifyRewards,
        notifyPromotions: notifyPromotions ?? this.notifyPromotions,
        notifyGeneral: notifyGeneral ?? this.notifyGeneral,
        useDeviceLocation: useDeviceLocation ?? this.useDeviceLocation,
        manualArea: manualArea ?? this.manualArea,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        referralCode: referralCode ?? this.referralCode,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'theme_mode': themeMode.name,
        if (languageCode != null) 'language_code': languageCode,
        'notify_stamps': notifyStamps,
        'notify_rewards': notifyRewards,
        'notify_promotions': notifyPromotions,
        'notify_general': notifyGeneral,
        'use_device_location': useDeviceLocation,
        if (manualArea != null) 'manual_area': manualArea,
        'onboarding_completed': onboardingCompleted,
        if (referralCode != null) 'referral_code': referralCode,
      };

  static ThemeMode _themeModeFromName(String? name) => switch (name) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}
