import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/presentation/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrap();
}

Future<void> _bootstrap() async {
  try {
    await initializeDateFormatting('es_MX');
    final preferences = await SharedPreferences.getInstance();
    runApp(ProviderScope(
      overrides: [preferencesProvider.overrideWithValue(preferences)],
      child: const PuntoPlusApp(),
    ));
  } on Object {
    runApp(MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
            body: SafeArea(
                child: Center(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.error_outline_rounded, size: 40),
                const SizedBox(height: 16),
                const Text(
                    'No se pudo abrir el almacenamiento local. Revisa el espacio disponible e inténtalo de nuevo.',
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                    onPressed: () => unawaited(_bootstrap()),
                    child: const Text('Reintentar')),
              ])),
        )))));
  }
}
