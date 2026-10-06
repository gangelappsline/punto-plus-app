"""Verificación del codificador QR en Dart.

Este script replica, línea por línea, el algoritmo implementado en
`lib/core/qr/qr_encoder.dart` y compara el resultado con `qrcodegen`
(implementación de referencia del estándar ISO/IEC 18004).

Uso:
    python3 tool/verify_qr_encoder.py
"""

from __future__ import annotations

import sys

import segno
from segno import consts

try:
    from qrcodegen import QrCode, QrCode as _QrCode, QrSegment
except ImportError:  # pragma: no cover
    print("Falta qrcodegen: pip install qrcodegen --break-system-packages")
    sys.exit(2)

# Niveles: etiqueta -> (bits de formato, clave de segno, ECC de qrcodegen)
LEVELS = {
    "L": (0x01, 1, _QrCode.Ecc.LOW),
    "M": (0x00, 0, _QrCode.Ecc.MEDIUM),
    "Q": (0x03, 3, _QrCode.Ecc.QUARTILE),
    "H": (0x02, 2, _QrCode.Ecc.HIGH),
}


def block_groups(level_key: int, version: int):
    """Grupos (bloques, total, datos) por versión, tal como los emite segno."""
    return [(ec.num_blocks, ec.num_total, ec.num_data)
            for ec in consts.ECC[version][level_key]]


def build_exp_table():
    table = [0] * 512
    value = 1
    for index in range(255):
        table[index] = value
        value <<= 1
        if value & 0x100:
            value ^= 0x11D
    for index in range(255, 512):
        table[index] = table[index - 255]
    return table


EXP = build_exp_table()
LOG = [0] * 256
for index in range(255):
    LOG[EXP[index]] = index


def multiply(left: int, right: int) -> int:
    if left == 0 or right == 0:
        return 0
    return EXP[LOG[left] + LOG[right]]


class BitBuffer:
    def __init__(self):
        self.bits: list[int] = []

    def append(self, value: int, count: int) -> None:
        for index in range(count - 1, -1, -1):
            self.bits.append((value >> index) & 1)

    def __len__(self) -> int:
        return len(self.bits)

    @property
    def bytes(self) -> list[int]:
        result = [0] * (len(self.bits) // 8)
        for index, bit in enumerate(self.bits):
            if bit:
                result[index >> 3] |= 0x80 >> (index & 7)
        return result


class Encoder:
    def __init__(self, level: str):
        self.level = level
        self.format_bits, self.level_key, _ = LEVELS[level]
        self.blocks = [block_groups(self.level_key, v) for v in range(1, 41)]

    def data_capacity_bits(self, version: int) -> int:
        return sum(blocks * data for blocks, _, data in
                   self.blocks[version - 1]) * 8

    @staticmethod
    def count_indicator_bits(version: int) -> int:
        return 8 if version <= 9 else 16

    def pick_version(self, byte_length: int) -> int:
        for version in range(1, 41):
            needed = 4 + self.count_indicator_bits(version) + byte_length * 8
            if needed <= self.data_capacity_bits(version):
                return version
        raise ValueError("contenido demasiado grande")

    def build_codewords(self, data: list[int], version: int) -> list[int]:
        capacity = self.data_capacity_bits(version)
        buffer = BitBuffer()
        buffer.append(0x04, 4)
        buffer.append(len(data), self.count_indicator_bits(version))
        for byte in data:
            buffer.append(byte, 8)
        buffer.append(0, min(4, capacity - len(buffer)))
        buffer.append(0, (8 - len(buffer) % 8) % 8)
        pad = True
        while len(buffer) < capacity:
            buffer.append(0xEC if pad else 0x11, 8)
            pad = not pad
        return buffer.bytes

    def generator_polynomial(self, degree: int) -> list[int]:
        polynomial = [1]
        for index in range(degree):
            nxt = [0] * (len(polynomial) + 1)
            for position, coefficient in enumerate(polynomial):
                nxt[position] ^= coefficient
                nxt[position + 1] ^= multiply(coefficient, EXP[index])
            polynomial = nxt
        return polynomial[1:]

    def reed_solomon(self, data: list[int], ec_length: int) -> list[int]:
        generator = self.generator_polynomial(ec_length)
        remainder = [0] * ec_length
        for byte in data:
            factor = byte ^ remainder[0]
            remainder = remainder[1:] + [0]
            for index in range(ec_length):
                remainder[index] ^= multiply(generator[index], factor)
        return remainder

    def interleave(self, data: list[int], version: int) -> list[int]:
        groups = self.blocks[version - 1]
        data_blocks: list[list[int]] = []
        ec_blocks: list[list[int]] = []
        offset = 0
        max_data = 0
        max_ec = 0
        for block_count, total, data_length in groups:
            for _ in range(block_count):
                chunk = data[offset:offset + data_length]
                offset += data_length
                data_blocks.append(chunk)
                ec_blocks.append(self.reed_solomon(chunk, total - data_length))
                max_data = max(max_data, data_length)
                max_ec = max(max_ec, total - data_length)
        assert offset == len(data), (offset, len(data))
        result: list[int] = []
        for index in range(max_data):
            for block in data_blocks:
                if index < len(block):
                    result.append(block[index])
        for index in range(max_ec):
            for block in ec_blocks:
                if index < len(block):
                    result.append(block[index])
        return result


class Matrix:
    """Espejo de `_Matrix` en `lib/core/qr/qr_encoder.dart`."""

    def __init__(self, version: int, modules=None, functions=None):
        self.version = version
        self.size = version * 4 + 17
        self.modules = modules or [[False] * self.size for _ in range(self.size)]
        self.functions = functions or [[False] * self.size for _ in range(self.size)]

    def copy(self) -> "Matrix":
        return Matrix(
            self.version,
            [row[:] for row in self.modules],
            [row[:] for row in self.functions],
        )

    def set(self, x: int, y: int, dark: bool) -> None:
        self.modules[y][x] = dark
        self.functions[y][x] = True

    def mark(self, x: int, y: int) -> None:
        self.functions[y][x] = True

    def draw_function_patterns(self) -> None:
        for index in range(self.size):
            self.set(6, index, index % 2 == 0)
            self.set(index, 6, index % 2 == 0)
        self.draw_finder(3, 3)
        self.draw_finder(self.size - 4, 3)
        self.draw_finder(3, self.size - 4)
        if self.version >= 2:
            positions = consts.ALIGNMENT_POS[self.version - 2]
            for x in positions:
                for y in positions:
                    overlaps = (
                        (x == 6 and y == 6)
                        or (x == 6 and y == self.size - 7)
                        or (x == self.size - 7 and y == 6)
                    )
                    if not overlaps:
                        self.draw_alignment(x, y)
        self.reserve_format_areas()
        if self.version >= 7:
            self.reserve_version_areas()

    def draw_finder(self, center_x: int, center_y: int) -> None:
        for dy in range(-4, 5):
            for dx in range(-4, 5):
                distance = max(abs(dx), abs(dy))
                x, y = center_x + dx, center_y + dy
                if 0 <= x < self.size and 0 <= y < self.size:
                    self.set(x, y, distance != 2 and distance != 4)

    def draw_alignment(self, center_x: int, center_y: int) -> None:
        for dy in range(-2, 3):
            for dx in range(-2, 3):
                self.set(center_x + dx, center_y + dy, max(abs(dx), abs(dy)) != 1)

    def reserve_format_areas(self) -> None:
        for index in range(9):
            self.mark(8, index)
            self.mark(index, 8)
        for index in range(1, 9):
            self.mark(8, self.size - index)
            self.mark(self.size - index, 8)
        self.set(8, self.size - 8, True)

    def reserve_version_areas(self) -> None:
        for index in range(6):
            for offset in range(3):
                self.mark(self.size - 11 + offset, index)
                self.mark(index, self.size - 11 + offset)

    def draw_codewords(self, codewords: list[int]) -> None:
        bits: list[int] = []
        for byte in codewords:
            for index in range(7, -1, -1):
                bits.append((byte >> index) & 1)
        index = 0
        right = self.size - 1
        while right >= 1:
            if right == 6:
                right -= 1
            for vertical in range(self.size):
                for column in range(2):
                    x = right - column
                    upward = ((right & 2) == 0) ^ (x < 6)
                    y = self.size - 1 - vertical if upward else vertical
                    if not self.functions[y][x] and index < len(bits):
                        self.modules[y][x] = bits[index] == 1
                        index += 1
            right -= 2
        assert index == len(bits), (index, len(bits))

    def apply_mask(self, mask: int) -> None:
        for y in range(self.size):
            for x in range(self.size):
                if self.functions[y][x]:
                    continue
                if self.mask_condition(mask, x, y):
                    self.modules[y][x] = not self.modules[y][x]

    @staticmethod
    def mask_condition(mask: int, x: int, y: int) -> bool:
        if mask == 0:
            return (x + y) % 2 == 0
        if mask == 1:
            return y % 2 == 0
        if mask == 2:
            return x % 3 == 0
        if mask == 3:
            return (x + y) % 3 == 0
        if mask == 4:
            return (x // 3 + y // 2) % 2 == 0
        if mask == 5:
            return x * y % 2 + x * y % 3 == 0
        if mask == 6:
            return (x * y % 2 + x * y % 3) % 2 == 0
        if mask == 7:
            return ((x + y) % 2 + x * y % 3) % 2 == 0
        return False

    def write_format_info(self, format_bits: int, mask: int) -> None:
        data = (format_bits << 3) | mask
        remainder = data
        for _ in range(10):
            remainder = (remainder << 1) ^ ((remainder >> 9) * 0x537)
        bits = (data << 10 | remainder) ^ 0x5412

        def bit(index: int) -> bool:
            return ((bits >> index) & 1) != 0

        for index in range(6):
            self.modules[index][8] = bit(index)
        self.modules[7][8] = bit(6)
        self.modules[8][8] = bit(7)
        self.modules[8][7] = bit(8)
        for index in range(9, 15):
            self.modules[8][14 - index] = bit(index)
        for index in range(8):
            self.modules[8][self.size - 1 - index] = bit(index)
        for index in range(8, 15):
            self.modules[self.size - 15 + index][8] = bit(index)
        self.modules[self.size - 8][8] = True

    def write_version_info(self) -> None:
        if self.version < 7:
            return
        remainder = self.version
        for _ in range(12):
            remainder = (remainder << 1) ^ ((remainder >> 11) * 0x1F25)
        bits = self.version << 12 | remainder
        for index in range(18):
            dark = ((bits >> index) & 1) != 0
            first = self.size - 11 + index % 3
            second = index // 3
            self.modules[second][first] = dark
            self.modules[first][second] = dark

    # --- Penalizaciones (reglas N1 a N4) --------------------------------
    def penalty_adjacent(self) -> int:
        score = 0
        for line in self.modules + [list(column) for column in zip(*self.modules)]:
            run_length = 1
            for index in range(1, len(line)):
                if line[index] == line[index - 1]:
                    run_length += 1
                    if run_length == 5:
                        score += 3
                    elif run_length > 5:
                        score += 1
                else:
                    run_length = 1
        return score

    def penalty_blocks(self) -> int:
        score = 0
        for y in range(self.size - 1):
            for x in range(self.size - 1):
                first = self.modules[y][x]
                if (
                    first == self.modules[y][x + 1]
                    and first == self.modules[y + 1][x]
                    and first == self.modules[y + 1][x + 1]
                ):
                    score += 3
        return score

    def penalty_patterns(self) -> int:
        pattern = [True, False, True, True, True, False, True]
        score = 0
        lines = self.modules + [list(column) for column in zip(*self.modules)]
        for line in lines:
            for index in range(len(line) - 6):
                if list(line[index:index + 7]) == pattern:
                    before = line[max(0, index - 4):index]
                    after = line[index + 7:index + 11]
                    if len(before) == 4 or len(after) == 4:
                        if not any(before) or not any(after):
                            score += 40
        return score

    def penalty_balance(self) -> int:
        dark = sum(1 for row in self.modules for module in row if module)
        total = self.size * self.size
        percent = dark / total
        steps = int(abs(percent * 100 - 50) / 5)
        return steps * 10

    def penalty(self) -> int:
        return (
            self.penalty_adjacent()
            + self.penalty_blocks()
            + self.penalty_patterns()
            + self.penalty_balance()
        )


def encode(text: str, level: str = "M"):
    encoder = Encoder(level)
    data = list(text.encode("utf-8"))
    version = encoder.pick_version(len(data))
    codewords = encoder.interleave(encoder.build_codewords(data, version), version)
    base = Matrix(version)
    base.draw_function_patterns()
    base.draw_codewords(codewords)

    best_mask = 0
    best_penalty = 1 << 30
    for mask in range(8):
        candidate = base.copy()
        candidate.apply_mask(mask)
        penalty = candidate.penalty()
        if penalty < best_penalty:
            best_penalty = penalty
            best_mask = mask

    result = base.copy()
    result.apply_mask(best_mask)
    result.write_format_info(encoder.format_bits, best_mask)
    result.write_version_info()
    return version, best_mask, result.modules


def reference_rows(text: str, level: str, mask: int):
    ecl = LEVELS[level][2]
    segments = [QrSegment.make_bytes(text.encode("utf-8"))]
    qr = QrCode.encode_segments(segments, ecl, mask=mask, boostecl=False)
    return qr.get_version(), [
        "".join("1" if qr.get_module(x, y) else "0" for x in range(qr.get_size()))
        for y in range(qr.get_size())
    ]


FIXTURES = [
    "PP-5F3A9C",
    "CARD-0001|CUSTOMER-42",
    "https://api.punto-plus.com.mx/api/customer/cards/12/qr?token=abc1234567890",
    "A" * 300,
    "ñáéíóú ¡Punto+! 1234567890",
]


def compare_penalties(text: str, level: str) -> tuple[int, int, list[int]]:
    """Compara la penalización de cada máscara con `segno.encoder.evaluate_mask`."""
    import segno.encoder as segno_encoder

    encoder = Encoder(level)
    data = list(text.encode("utf-8"))
    version = encoder.pick_version(len(data))
    codewords = encoder.interleave(encoder.build_codewords(data, version), version)
    base = Matrix(version)
    base.draw_function_patterns()
    base.draw_codewords(codewords)

    mine: list[int] = []
    theirs: list[int] = []
    for mask in range(8):
        candidate = base.copy()
        candidate.apply_mask(mask)
        size = candidate.size
        matrix = [
            bytearray(1 if module else 0 for module in row)
            for row in candidate.modules
        ]
        mine.append(candidate.penalty())
        theirs.append(segno_encoder.evaluate_mask(matrix, size, size))
    mismatch = sum(1 for a, b in zip(mine, theirs) if a != b)
    same_choice = mine.index(min(mine)) == theirs.index(min(theirs))
    return mismatch, len(mine) if same_choice else -1, mine


def main() -> int:
    failures = 0
    for text in FIXTURES:
        for level in ("L", "M", "Q", "H"):
            version, mask, modules = encode(text, level)
            ref_version, ref_rows = reference_rows(text, level, mask)
            mine = [
                "".join("1" if module else "0" for module in row)
                for row in modules
            ]
            if version != ref_version:
                failures += 1
                print(f"✗ versión distinta ({level}): {version} != {ref_version}")
                continue
            if mine != ref_rows:
                failures += 1
                diff = sum(
                    1
                    for row_mine, row_ref in zip(mine, ref_rows)
                    for a, b in zip(row_mine, row_ref)
                    if a != b
                )
                print(f"✗ máscara {mask}: {diff} módulos distintos ({level}, {text[:20]!r})")
                continue
            print(f"✓ {level} v{version} máscara {mask} {len(mine)}x{len(mine)}")
    penalty_failures = 0
    for text in FIXTURES:
        for level in ("L", "M", "Q", "H"):
            mismatches, same_choice, _ = compare_penalties(text, level)
            if mismatches:
                penalty_failures += 1
                print(f"✗ penalizaciones distintas de segno ({level}, {text[:16]!r}): {mismatches}")
            elif same_choice == -1:
                penalty_failures += 1
                print(f"✗ la máscara elegida difiere de segno ({level}, {text[:16]!r})")
    if not penalty_failures:
        print()
        print("Penalizaciones N1-N4 idénticas a segno y misma máscara elegida")

    print()
    if failures:
        print(f"{failures} comparaciones fallaron")
        return 1
    if penalty_failures:
        print(f"{penalty_failures} comparaciones de penalización fallaron")
        return 1
    print("Todas las matrices coinciden con qrcodegen")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
