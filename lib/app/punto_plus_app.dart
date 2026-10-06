import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/app_providers.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'app_router.dart';

/// Raíz de la aplicación: tema, idioma y enrutado.
final class PuntoPlusApp extends ConsumerWidget {
  const PuntoPlusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider);
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Punto+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: preferences.themeMode,
      locale: preferences.locale,
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (
        Locale? locale,
        Iterable<Locale> supported,
      ) =>
          preferences.locale ??
          (locale == null
              ? supported.first
              : AppLocalizations.forLocale(locale).locale),
      routerConfig: router,
      builder: (BuildContext context, Widget? child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: 0.9,
        maxScaleFactor: 1.3,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
