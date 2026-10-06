import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/qr/qr_encoder.dart';

void main() {
  group('QrCode.encodeText', () {
    test('elige la versión más pequeña que admite el contenido', () {
      expect(QrCode.encodeText('A').version, 1);
      expect(QrCode.encodeText('A' * 14, level: QrErrorCorrection.medium).version, 1);
      expect(QrCode.encodeText('A' * 15, level: QrErrorCorrection.medium).version, 2);
      // Nivel H reduce la capacidad: el mismo texto sube de versión.
      expect(QrCode.encodeText('A' * 15, level: QrErrorCorrection.high).version, 3);
    });

    test('informa tamaño, nivel y máscara aplicada', () {
      final QrCode qr = QrCode.encodeText('PP-5F3A9C');
      expect(qr.size, qr.version * 4 + 17);
      expect(qr.level, QrErrorCorrection.medium);
      expect(qr.mask, inInclusiveRange(0, 7));
      expect(qr.modules.length, qr.size);
      expect(qr.modules.every((List<bool> row) => row.length == qr.size), isTrue);
    });

    test('codifica acentos y emojis en UTF-8', () {
      final QrCode qr = QrCode.encodeText('Café + ñ 🎉');
      expect(qr.version, greaterThanOrEqualTo(1));
      expect(qr.rows.length, qr.size);
    });

    test('la matriz cambia con el contenido', () {
      final QrCode first = QrCode.encodeText('AAAA');
      final QrCode second = QrCode.encodeText('BBBB');
      expect(first.rows, isNot(equals(second.rows)));
    });

    test('rechaza contenido mayor que la versión 40', () {
      expect(
        () => QrCode.encodeText('A' * 5000),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('respeta los bits del indicador de longitud según la versión', () {
      expect(
        QrErrorCorrection.medium.countIndicatorBits(1),
        8,
      );
      expect(
        QrErrorCorrection.medium.countIndicatorBits(9),
        8,
      );
      expect(
        QrErrorCorrection.medium.countIndicatorBits(10),
        16,
      );
    });

    test('la capacidad de datos crece con la versión y baja con el nivel', () {
      expect(
        QrErrorCorrection.medium.dataCapacityBits(1),
        16 * 8,
      );
      expect(
        QrErrorCorrection.high.dataCapacityBits(1),
        9 * 8,
      );
      expect(
        QrErrorCorrection.medium.dataCapacityBits(2),
        greaterThan(QrErrorCorrection.medium.dataCapacityBits(1)),
      );
    });
  });
}
