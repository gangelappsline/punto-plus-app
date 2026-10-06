#!/usr/bin/env python3
"""Genera tablas QR y fixtures de referencia para la app Flutter.

El codificador QR vive en `lib/core/qr/qr_encoder.dart` y no depende de
plugins. Las tablas que conviene generar (estructura de bloques Reed-Solomon
y posiciones de los patrones de alineación) se extraen de `segno`, una
implementación madura y verificada, para evitar errores de transcripción.

También escribe `test/core/qr/qr_reference_test.dart` con matrices esperadas
producidas por `qrcodegen` (referencia independiente del estándar), forzando
la máscara que elige el algoritmo de la app. Dicha máscara se valida contra
`segno` en `tool/verify_qr_encoder.py`.

Requisitos: `pip install segno qrcodegen`

Uso: python3 tool/generate_qr_tables.py
"""

from __future__ import annotations

import pathlib
import sys

try:
    import segno  # noqa: F401
    import segno.consts as consts
    from qrcodegen import QrCode as ReferenceQr
    from qrcodegen import QrSegment
except ImportError:  # pragma: no cover
    print("Instala segno y qrcodegen", file=sys.stderr)
    raise SystemExit(1)

import importlib.util

_spec = importlib.util.spec_from_file_location(
    "qr_mirror", pathlib.Path(__file__).resolve().parent / "verify_qr_encoder.py"
)
mirror = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(mirror)

REFERENCE_LEVELS = {
    "L": ReferenceQr.Ecc.LOW,
    "M": ReferenceQr.Ecc.MEDIUM,
    "Q": ReferenceQr.Ecc.QUARTILE,
    "H": ReferenceQr.Ecc.HIGH,
}

ROOT = pathlib.Path(__file__).resolve().parents[1]
TABLE_OUTPUT = ROOT / "lib" / "core" / "qr" / "qr_tables.dart"
TEST_OUTPUT = ROOT / "test" / "core" / "qr" / "qr_reference_test.dart"

# Índices de nivel de corrección en segno.
SEGNO_LEVELS = {"L": 1, "M": 0, "Q": 3, "H": 2}

FIXTURES = [
    "PP-5F3A9C",
    "CARD-0001|CUSTOMER-42",
    "https://api.punto-plus.com.mx/api/customer/cards/12/qr?token=8f3a9c21",
    "A" * 300,
    "fixture-de-prueba-1234567890",
]

# Matrices esperadas: `qrcodegen` (implementación de referencia del estándar)
# con la máscara que elige el propio algoritmo validado contra segno.
FIXTURE_LEVEL = "M"

TABLE_HEADER = """// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Fuente: segno (tablas del estándar ISO/IEC 18004).
// Regenerar con: python3 tool/generate_qr_tables.py

/// Grupo de bloques Reed-Solomon de una versión.
///
/// Formato: `[bloques, codewordsTotalesPorBloque, codewordsDeDatosPorBloque]`.
typedef QrBlockGroup = List<int>;

"""

TEST_HEADER = """// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Matrices esperadas producidas por `qrcodegen` (implementación de referencia
// del estándar ISO/IEC 18004, modo byte, nivel M). La máscara esperada es la
// que elige el algoritmo de la app, validado contra `segno`.
// Regenerar con: python3 tool/generate_qr_tables.py

import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus/core/qr/qr_encoder.dart';

List<String> renderRows(QrCode qr) => qr.modules
    .map(
      (List<bool> row) => row.map((bool module) => module ? '1' : '0').join(),
    )
    .toList();

void main() {
  group('QrCode.encodeText (referencia qrcodegen)', () {
"""


def dart_list(items: list[str], indent: str = "  ") -> str:
    return "\n".join(f"{indent}{item}," for item in items)


def build_tables() -> str:
    sections: list[str] = [TABLE_HEADER]
    for name, level in SEGNO_LEVELS.items():
        groups: list[str] = []
        for version in range(1, 41):
            blocks = consts.ECC[version][level]
            entries = ", ".join(
                f"[{b.num_blocks}, {b.num_total}, {b.num_data}]" for b in blocks
            )
            groups.append(f"<QrBlockGroup>[{entries}]")
        sections.append(
            f"/// Grupos de bloques por versión (índice 0 = versión 1) "
            f"para el nivel {name}.\n"
            f"const List<List<QrBlockGroup>> qrBlockGroups{name} = "
            f"<List<QrBlockGroup>>[\n{dart_list(groups)}\n];\n\n"
        )

    sections.append(
        "/// Posiciones de los patrones de alineación por versión "
        "(índice 0 = versión 2).\n"
        "const List<List<int>> qrAlignmentPositions = <List<int>>[\n"
        + dart_list(
            [
                "<int>["
                + ", ".join(str(value) for value in consts.ALIGNMENT_POS[version - 2])
                + "]"
                for version in range(2, 41)
            ]
        )
        + "\n];\n"
    )
    return "".join(sections)


def dart_string(value: str) -> str:
    escaped = (
        value.replace("\\", "\\\\").replace("'", r"\'").replace("$", r"\$")
    )
    return f"'{escaped}'"


def reference_rows(text: str, level: str, mask: int) -> tuple[int, list[str]]:
    qr = ReferenceQr.encode_segments(
        [QrSegment.make_bytes(text.encode("utf-8"))],
        REFERENCE_LEVELS[level],
        boostecl=False,
        mask=mask,
    )
    size = qr.get_size()
    rows = [
        "".join("1" if qr.get_module(x, y) else "0" for x in range(size))
        for y in range(size)
    ]
    return qr.get_version(), rows


def build_test() -> str:
    cases: list[str] = []
    for index, text in enumerate(FIXTURES):
        level = FIXTURE_LEVEL
        version, mask, _ = mirror.encode(text, level)
        ref_version, rows = reference_rows(text, level, mask)
        if ref_version != version:
            raise SystemExit(
                f"La referencia eligió la versión {ref_version} y la app {version}"
            )
        rows_literal = "\n".join("        '%s'," % row for row in rows)
        cases.append(
            f"""
    test('caso {index + 1}: {len(text.encode('utf-8'))} bytes, '
        'versión {version}, máscara {mask}', () {{
      const String content = {dart_string(text)};
      final QrCode qr =
          QrCode.encodeText(content, level: QrErrorCorrection.medium);
      expect(qr.version, {version});
      expect(qr.mask, {mask});
      expect(qr.size, {len(rows)});
      const List<String> expected = <String>[
{rows_literal}
      ];
      expect(renderRows(qr), expected);
    }});"""
        )

    return TEST_HEADER + "\n".join(cases) + "\n  });\n}\n"


def main() -> int:
    TABLE_OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    TEST_OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    TABLE_OUTPUT.write_text(build_tables(), encoding="utf-8")
    TEST_OUTPUT.write_text(build_test(), encoding="utf-8")
    print(
        f"{TABLE_OUTPUT.relative_to(ROOT)} y "
        f"{TEST_OUTPUT.relative_to(ROOT)} generados"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
