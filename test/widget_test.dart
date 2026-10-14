import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:punto_plus_app/app/app.dart';
import 'package:punto_plus_app/app/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> launch(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await initializeDateFormatting('es_MX');
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ProviderScope(overrides: [
      preferencesProvider.overrideWithValue(prefs),
      connectivityProvider
          .overrideWith((ref) => Stream.value([ConnectivityResult.wifi])),
    ], child: const PuntoPlusApp()));
    await tester.pumpAndSettle();
  }

  testWidgets('welcome opens customer wallet and card detail', (tester) async {
    await launch(tester);
    final enter = find.byKey(const Key('enter-customer'));
    await tester.ensureVisible(enter);
    await tester.tap(enter);
    await tester.pumpAndSettle();
    expect(find.text('Lo bueno de volver.'), findsOneWidget);
    final card = find.text('Café Origen');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.text('Tu tarjeta'), findsOneWidget);
    expect(find.text('QR DE DEMOSTRACIÓN'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('business opens scanner without requesting camera automatically',
      (tester) async {
    await launch(tester);
    final enter = find.byKey(const Key('enter-business'));
    await tester.ensureVisible(enter);
    await tester.tap(enter);
    await tester.pumpAndSettle();
    expect(find.text('Hola, Café Origen.'), findsOneWidget);
    await tester.tap(find.text('Registrar una visita'));
    await tester.pumpAndSettle();
    expect(find.text('Activar cámara'), findsOneWidget);
    expect(find.text('Probar con el cliente demo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
