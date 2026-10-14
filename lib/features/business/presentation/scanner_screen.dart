import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/providers.dart';
import '../../../core/presentation/theme.dart';
import '../../../core/presentation/widgets.dart';
import '../../demo/data/demo_seed.dart';
import '../domain/demo_qr.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});
  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  final _controller =
      MobileScannerController(autoStart: false, formats: [BarcodeFormat.qrCode]);
  final _manual = TextEditingController();
  bool _camera = false;
  bool _handling = false;
  bool _success = false;
  String? _cameraError;
  String? _pendingQr;
  String? _operationId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_controller.dispose().catchError((Object _) {
      // Disposing must not crash if the platform camera was never available.
    }));
    _manual.dispose();
    super.dispose();
  }

  Future<void> _stopCamera() async {
    try {
      await _controller.stop();
    } on Object {/* Camera may already be stopped. */}
  }

  Future<void> _startCamera() async {
    try {
      await _controller.start();
    } on Object {
      if (mounted) {
        setState(() => _cameraError =
            'No se pudo iniciar la cámara. Revisa los permisos o utiliza el código manual.');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_camera) {
      return;
    }
    if (state == AppLifecycleState.resumed && !_handling && !_success) {
      unawaited(_startCamera());
    } else if (state != AppLifecycleState.resumed) {
      unawaited(_stopCamera());
    }
  }

  Future<void> _handle(String value) async {
    if (_handling || _success || ref.read(offlineProvider)) {
      return;
    }
    setState(() => _handling = true);
    await _stopCamera();
    try {
      final decoded = DemoQr.parse(value);
      if (!mounted) {
        return;
      }
      final confirmed = await confirmAction(context,
          title: 'Registrar una visita',
          message:
              'Se agregará 1 sello a la tarjeta ${decoded.cardId} del cliente demo. Confirma que corresponde a una nueva compra.',
          confirm: 'Agregar sello');
      if (!confirmed || !mounted) {
        return;
      }
      if (_pendingQr != value) {
        _pendingQr = value;
        _operationId = newOperationId();
      }
      await ref.read(actionsProvider).purchase(value, _operationId!);
      if (!mounted) {
        return;
      }
      setState(() => _success = true);
      showMessage(context, '¡Un sello más! Visita registrada en demo.');
    } on Object catch (error) {
      if (mounted) {
        showMessage(context, friendlyError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _handling = false);
        // No automatic restart: avoids repeated dialogs and accidental scans.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final offline = ref.watch(offlineProvider);
    return ListView(padding: const EdgeInsets.all(24), children: [
      Row(children: [
        IconButton(
            onPressed: () => context.go('/business'),
            tooltip: 'Volver al negocio',
            icon: const Icon(Icons.arrow_back_rounded)),
        Expanded(child: Text('Registrar visita', style: Theme.of(context).textTheme.titleLarge)),
      ]),
      const SizedBox(height: 24),
      if (_success) ...[
        const EmptyState(
            icon: Icons.check_circle_outline_rounded,
            title: '¡Visita registrada!',
            subtitle: 'El cliente demo ya tiene un sello más en Café Origen.'),
        FilledButton(
            onPressed: () {
              setState(() {
                _success = false;
                _pendingQr = null;
                _operationId = null;
              });
              if (_camera) {
                unawaited(_startCamera());
              }
            },
            child: const Text('Registrar otra compra')),
      ] else ...[
        const Text('Escanea el QR de tu cliente',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Solo se aceptan QRs de esta demo para Café Origen.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 24),
        if (_camera)
          ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                  height: 290,
                  child: Stack(children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: (capture) {
                        final values = capture.barcodes
                            .map((barcode) => barcode.rawValue)
                            .whereType<String>();
                        if (values.isNotEmpty) {
                          unawaited(_handle(values.first));
                        }
                      },
                      errorBuilder: (_, error, __) => const ColoredBox(
                          color: canvas,
                          child: EmptyState(
                            icon: Icons.no_photography_outlined,
                            title: 'Cámara no disponible',
                            subtitle:
                                'Permite el acceso en Ajustes o ingresa el código manualmente.',
                          )),
                    ),
                    Center(
                        child: IgnorePointer(
                            child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    border: Border.all(color: lime, width: 3),
                                    borderRadius: BorderRadius.circular(20))))),
                  ]))),
        if (_cameraError != null)
          Padding(
              padding: const EdgeInsets.all(12), child: Text(_cameraError!)),
        const SizedBox(height: 12),
        OutlinedButton.icon(
            onPressed: _handling || offline
                ? null
                : () {
                    setState(() {
                      _camera = true;
                      _cameraError = null;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        unawaited(_startCamera());
                      }
                    });
                  },
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(_camera ? 'Reanudar cámara' : 'Activar cámara')),
        const SectionHeader('También puedes pegar un código'),
        TextField(
            controller: _manual,
            enabled: !_handling,
            maxLength: 2048,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
                labelText: 'Contenido del QR demo', counterText: '')),
        const SizedBox(height: 12),
        FilledButton(
            onPressed: _handling || offline
                ? null
                : () => _handle(_manual.text.trim()),
            child: Text(_handling ? 'Procesando…' : 'Validar código')),
        const SizedBox(height: 24),
        TextButton.icon(
            onPressed: _handling || offline
                ? null
                : () => _handle(
                    const DemoQr(memberId: demoMemberId, cardId: 'card-origen')
                        .encode()),
            icon: const Icon(Icons.science_outlined),
            label: const Text('Probar con el cliente demo')),
      ],
      const SizedBox(height: 20),
      const Text(
          'No se registran compras automáticamente. Cada sello requiere tu confirmación. Las operaciones demo no tienen valor real.',
          textAlign: TextAlign.center,
          style: TextStyle(color: muted, fontSize: 12)),
    ]);
  }
}
