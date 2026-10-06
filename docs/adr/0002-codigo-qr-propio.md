# 0002. Codificador QR propio verificado por vectores

- **Fecha**: 2026-01
- **Estado**: Aceptada

## Contexto

`qr_flutter` no pudo instalarse (sin acceso a pub.dev). El QR es la pieza
central del producto: si el símbolo está mal, ningún negocio puede registrar
sellos.

## Decisión

- Implementar ISO/IEC 18004 en Dart puro en `lib/core/qr/qr_encoder.dart`
  (segmentación numérica/alfanumérica/byte, Reed-Solomon, entrelazado,
  penalizaciones N1–N4 y elección de máscara).
- Renderizar con `QrView` (`CustomPainter`) en lugar de un paquete.
- Verificar con `tool/verify_qr_encoder.py`, que compara la salida con
  `qrcodegen` (Python) y con `segno`, incluidas las penalizaciones y la máscara
  elegida.
- Congelar vectores de referencia en `test/core/qr/qr_reference_test.dart`,
  regenerables con `tool/generate_qr_tables.py`.

## Consecuencias

- El encoder está probado contra dos implementaciones independientes y no
  agrega dependencias.
- La máscara elegida puede diferir de la de `qrcodegen` (ambas son válidas según
  la norma): los vectores fijan la máscara que calcula la app y las
  penalizaciones coinciden con `segno`.
- Si más adelante se adopta `qr_flutter`, `QrView` se puede sustituir sin tocar
  las pantallas.
