import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/theme/app_theme.dart';
import 'package:punto_plus/core/widgets/app_button.dart';
import 'package:punto_plus/core/widgets/app_text_field.dart';
import 'package:punto_plus/core/widgets/feedback.dart';
import 'package:punto_plus/core/widgets/progress.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  testWidgets('PrimaryButton muestra carga y se bloquea mientras carga',
      (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      host(
        PrimaryButton(
          label: 'Continuar',
          isLoading: true,
          onPressed: () => taps++,
        ),
      ),
    );

    expect(find.text('Continuar'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    expect(taps, 0);
  });

  testWidgets('PrimaryButton dispara la acción cuando está habilitado',
      (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      host(PrimaryButton(label: 'Continuar', onPressed: () => taps++)),
    );

    await tester.tap(find.text('Continuar'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('EmptyStateView muestra la acción opcional',
      (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      host(
        EmptyStateView(
          icon: Icons.card_giftcard_rounded,
          title: 'Sin premios',
          message: 'Acumula sellos para desbloquear premios.',
          actionLabel: 'Reintentar',
          onAction: () => taps++,
        ),
      ),
    );

    expect(find.text('Sin premios'), findsOneWidget);
    expect(find.text('Acumula sellos para desbloquear premios.'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('ErrorStateView reintenta y muestra el mensaje',
      (WidgetTester tester) async {
    int retries = 0;
    await tester.pumpWidget(
      host(
        ErrorStateView(
          message: 'No pudimos cargar tus tarjetas.',
          onRetry: () => retries++,
        ),
      ),
    );

    expect(find.text('No pudimos cargar tus tarjetas.'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(retries, 1);
  });

  testWidgets('StampsGrid dibuja un sello por cada sello requerido',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      host(
        const StampsGrid(
          stampsCount: 3,
          requiredStamps: 8,
          columns: 4,
          animate: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StampCell), findsNWidgets(8));
  });

  testWidgets('SearchField limpia el texto con el botón de cerrar',
      (WidgetTester tester) async {
    final TextEditingController controller =
        TextEditingController(text: 'café');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      host(
        SearchField(
          controller: controller,
          hintText: 'Buscar negocios',
          onClear: controller.clear,
        ),
      ),
    );

    expect(find.text('café'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(controller.text, isEmpty);
  });
}
