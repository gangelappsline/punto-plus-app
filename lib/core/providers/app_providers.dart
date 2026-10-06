import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../models/app_preferences.dart';
import '../storage/preferences_store.dart';
import 'data_providers.dart';

export 'data_providers.dart';

/// Estado global de sesión.
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Preferencias locales (tema, idioma, avisos y ubicación).
final appPreferencesProvider =
    NotifierProvider<PreferencesController, AppPreferences>(
  PreferencesController.new,
);

/// Usuario autenticado o `null`.
final currentUserProvider = Provider<UserModel?>(
  (Ref ref) => ref.watch(authControllerProvider).session?.user,
);

/// `true` cuando hay sesión activa.
final isAuthenticatedProvider = Provider<bool>(
  (Ref ref) => ref.watch(authControllerProvider).session != null,
);

/// `true` cuando el usuario puede ver el modo negocio.
final isBusinessUserProvider = Provider<bool>(
  (Ref ref) =>
      ref.watch(currentUserProvider)?.role.isBusiness ?? false,
);

/// Estado de conectividad reportado por las peticiones HTTP.
final networkStatusProvider = StreamProvider<bool>(
  (Ref ref) => ref.watch(networkMonitorProvider).stream,
);

/// Controla las preferencias del usuario y su persistencia.
final class PreferencesController extends Notifier<AppPreferences> {
  late PreferencesStore _store;

  @override
  AppPreferences build() {
    _store = ref.watch(preferencesStoreProvider);
    Future<void>.microtask(_hydrate);
    return const AppPreferences();
  }

  Future<void> _hydrate() async {
    final AppPreferences stored = await _store.load();
    state = stored;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _store.save(state);
  }

  Future<void> setLanguage(String? languageCode) async {
    state = languageCode == null
        ? state.copyWith(clearLanguage: true)
        : state.copyWith(languageCode: languageCode);
    await _store.save(state);
  }

  Future<void> setNotification({
    bool? stamps,
    bool? rewards,
    bool? promotions,
    bool? general,
  }) async {
    state = state.copyWith(
      notifyStamps: stamps,
      notifyRewards: rewards,
      notifyPromotions: promotions,
      notifyGeneral: general,
    );
    await _store.save(state);
  }

  Future<void> setUseDeviceLocation(bool value) async {
    state = state.copyWith(useDeviceLocation: value);
    await _store.save(state);
  }

  Future<void> setManualArea(String area) async {
    state = state.copyWith(manualArea: area);
    await _store.save(state);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingCompleted: true);
    await _store.save(state);
  }

  Future<void> setReferralCode(String code) async {
    state = state.copyWith(referralCode: code);
    await _store.save(state);
  }

  Future<void> reset() async {
    await _store.clear();
    state = const AppPreferences();
  }
}
