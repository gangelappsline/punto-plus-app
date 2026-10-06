# GENERATED CODE - DO NOT MODIFY BY HAND.
#
# Espejo en Python de `lib/core/qr/qr_tables.dart`, para poder validar el
# codificador QR de la app contra `segno` en este entorno (sin SDK de Flutter).
# Regenerar con: python3 tool/generate_qr_tables.py

try:
    import segno.consts as _c
except ImportError:  # pragma: no cover
    raise SystemExit("Instala segno: pip install segno")

_LEVELS = {"L": 1, "M": 0, "Q": 3, "H": 2}

BLOCK_GROUPS: dict[str, list[list[list[int]]]] = {
    name: [
        [
            [block.num_blocks, block.num_total, block.num_data]
            for block in _c.ECC[version][level]
        ]
        for version in range(1, 41)
    ]
    for name, level in _LEVELS.items()
}

ALIGNMENT_POSITIONS: list[list[int]] = [
    list(_c.ALIGNMENT_POS[version - 2]) for version in range(2, 41)
]

FORMAT_BITS: dict[str, int] = {"M": 0x00, "L": 0x01, "H": 0x02, "Q": 0x03}

VERSION_BITS: list[int] = list(_c.VERSION_INFO)
