import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import 'qr_encoder.dart';

/// Dibuja un [QrCode] en pantalla (sin plugins ni dependencias externas).
final class QrView extends StatelessWidget {
  const QrView({
    required this.qr,
    this.size,
    this.foregroundColor,
    this.backgroundColor,
    this.padding = 16,
    this.borderRadius = 16,
    this.semanticLabel,
    super.key,
  });

  /// Construye el código a partir de un texto.
  factory QrView.fromText(
    String text, {
    Key? key,
    double? size,
    QrErrorCorrection level = QrErrorCorrection.medium,
    Color? foregroundColor,
    Color? backgroundColor,
    double padding = 16,
    double borderRadius = 16,
    String? semanticLabel,
  }) =>
      QrView(
        key: key,
        qr: QrCode.encodeText(text, level: level),
        size: size,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: padding,
        borderRadius: borderRadius,
        semanticLabel: semanticLabel,
      );

  final QrCode qr;
  final double? size;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double padding;
  final double borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Color foreground = foregroundColor ?? Colors.black;
    final Color background = backgroundColor ?? Colors.white;
    return Semantics(
      label: semanticLabel ?? context.l10n.qrCodeLabel,
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CustomPaint(
          painter: QrPainter(
            qr: qr,
            foregroundColor: foreground,
            backgroundColor: background,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// Pinta la matriz del símbolo QR escalada al tamaño disponible.
final class QrPainter extends CustomPainter {
  const QrPainter({
    required this.qr,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final QrCode qr;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final int modules = qr.size;
    final double moduleSize = size.shortestSide / modules;
    final Paint background = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, background);

    final Paint foreground = Paint()
      ..color = foregroundColor
      ..isAntiAlias = false;

    for (int y = 0; y < modules; y++) {
      for (int x = 0; x < modules; x++) {
        if (!qr.modules[y][x]) continue;
        canvas.drawRect(
          Rect.fromLTWH(
            x * moduleSize,
            y * moduleSize,
            // Se solapan ligeramente para evitar líneas claras al escalar.
            moduleSize + 0.5,
            moduleSize + 0.5,
          ),
          foreground,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant QrPainter oldDelegate) =>
      oldDelegate.qr != qr ||
      oldDelegate.foregroundColor != foregroundColor ||
      oldDelegate.backgroundColor != backgroundColor;
}
