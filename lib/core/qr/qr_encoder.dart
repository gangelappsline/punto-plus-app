import 'dart:convert';
import 'dart:math' as math;

import 'qr_tables.dart';

/// Nivel de corrección de errores del símbolo QR.
enum QrErrorCorrection {
  low('L', 0x01, qrBlockGroupsL),
  medium('M', 0x00, qrBlockGroupsM),
  quartile('Q', 0x03, qrBlockGroupsQ),
  high('H', 0x02, qrBlockGroupsH);

  const QrErrorCorrection(this.label, this.formatBits, this.blockGroups);

  final String label;

  /// Bits que identifican el nivel dentro de la información de formato.
  final int formatBits;

  /// Estructura de bloques Reed-Solomon por versión (índice 0 = versión 1).
  final List<List<QrBlockGroup>> blockGroups;

  /// Bits disponibles para datos (cabecera de modo y longitud incluidos).
  int dataCapacityBits(int version) => blockGroups[version - 1].fold(
        0,
        (int total, QrBlockGroup group) => total + group[0] * group[2],
      ) *
      8;

  /// Bits del indicador de longitud del modo byte según la versión.
  int countIndicatorBits(int version) => version <= 9 ? 8 : 16;
}

/// Símbolo QR completo (módulos ya enmascarados y con información de formato).
final class QrCode {
  const QrCode({
    required this.version,
    required this.level,
    required this.mask,
    required this.modules,
  });

  /// Codifica `text` como símbolo QR en modo byte.
  ///
  /// Elige la versión más pequeña que admite el contenido y la máscara con la
  /// penalización más baja, según ISO/IEC 18004.
  static QrCode encodeText(
    String text, {
    QrErrorCorrection level = QrErrorCorrection.medium,
  }) =>
      QrEncoder(level: level).encode(text);

  /// Versión del símbolo (1..40).
  final int version;
  final QrErrorCorrection level;

  /// Máscara aplicada (0..7).
  final int mask;

  /// `modules[y][x] == true` significa módulo oscuro.
  final List<List<bool>> modules;

  int get size => modules.length;

  /// Filas como cadenas de '0'/'1' (pruebas y depuración).
  List<String> get rows => modules
      .map(
        (List<bool> row) => row.map((bool dark) => dark ? '1' : '0').join(),
      )
      .toList();
}

/// Codificador QR en modo byte, sin dependencias externas.
final class QrEncoder {
  QrEncoder({this.level = QrErrorCorrection.medium});

  final QrErrorCorrection level;

  /// Tabla de antilogaritmos en GF(256) con polinomio primitivo 0x11D.
  static final List<int> _exp = _buildExpTable();

  /// Tabla de logaritmos (inversa de [_exp]).
  static final List<int> _log = _buildLogTable(_exp);

  static List<int> _buildExpTable() {
    final List<int> table = List<int>.filled(512, 0);
    int value = 1;
    for (int index = 0; index < 255; index++) {
      table[index] = value;
      value <<= 1;
      if (value & 0x100 != 0) value ^= 0x11D;
    }
    for (int index = 255; index < 512; index++) {
      table[index] = table[index - 255];
    }
    return table;
  }

  static List<int> _buildLogTable(List<int> exp) {
    final List<int> table = List<int>.filled(256, 0);
    for (int index = 0; index < 255; index++) {
      table[exp[index]] = index;
    }
    return table;
  }

  QrCode encode(String text) {
    final List<int> data = utf8.encode(text);
    final int version = _pickVersion(data.length);
    final List<int> codewords =
        _interleave(_buildCodewords(data, version), version);

    final _Matrix base = _Matrix(version)
      ..drawFunctionPatterns()
      ..drawCodewords(codewords);

    int bestMask = 0;
    int bestPenalty = 1 << 30;
    for (int mask = 0; mask < 8; mask++) {
      final _Matrix candidate = base.copy()..applyMask(mask);
      // La evaluación se hace sin información de formato ni de versión: esas
      // áreas forman parte de los patrones de función, no de la región de
      // datos (ISO/IEC 18004, 7.8.3).
      final int penalty = candidate.penaltyScore();
      if (penalty < bestPenalty) {
        bestPenalty = penalty;
        bestMask = mask;
      }
    }

    final _Matrix result = base.copy()
      ..applyMask(bestMask)
      ..writeFormatInfo(level, bestMask)
      ..writeVersionInfo();
    return QrCode(
      version: version,
      level: level,
      mask: bestMask,
      modules: result.snapshot(),
    );
  }

  int _pickVersion(int byteLength) {
    for (int version = 1; version <= 40; version++) {
      final int needed =
          4 + level.countIndicatorBits(version) + byteLength * 8;
      if (needed <= level.dataCapacityBits(version)) return version;
    }
    throw ArgumentError.value(
      byteLength,
      'text',
      'El contenido excede la capacidad de un símbolo QR de 40 versiones.',
    );
  }

  /// Modo byte + longitud + datos + terminador + relleno alternado.
  List<int> _buildCodewords(List<int> data, int version) {
    final int capacityBits = level.dataCapacityBits(version);
    final _BitBuffer buffer = _BitBuffer()
      ..append(0x04, 4)
      ..append(data.length, level.countIndicatorBits(version));
    for (final int byte in data) {
      buffer.append(byte, 8);
    }
    buffer.append(0, math.min(4, capacityBits - buffer.length));
    buffer.append(0, (8 - buffer.length % 8) % 8);

    bool useExtraPadByte = true;
    while (buffer.length < capacityBits) {
      buffer.append(useExtraPadByte ? 0xEC : 0x11, 8);
      useExtraPadByte = !useExtraPadByte;
    }
    return buffer.bytes;
  }

  /// Divide en bloques, calcula Reed-Solomon y entrelaza.
  List<int> _interleave(List<int> data, int version) {
    final List<QrBlockGroup> groups = level.blockGroups[version - 1];
    final List<List<int>> dataBlocks = <List<int>>[];
    final List<List<int>> ecBlocks = <List<int>>[];
    int offset = 0;
    int maxDataLength = 0;
    int maxEcLength = 0;

    for (final QrBlockGroup group in groups) {
      final int blockCount = group[0];
      final int totalLength = group[1];
      final int dataLength = group[2];
      for (int block = 0; block < blockCount; block++) {
        final List<int> blockData = data.sublist(offset, offset + dataLength);
        offset += dataLength;
        dataBlocks.add(blockData);
        ecBlocks.add(_reedSolomon(blockData, totalLength - dataLength));
        maxDataLength = math.max(maxDataLength, dataLength);
        maxEcLength = math.max(maxEcLength, totalLength - dataLength);
      }
    }
    assert(offset == data.length, 'Codewords de datos sobrantes o faltantes');

    final List<int> result = <int>[];
    for (int index = 0; index < maxDataLength; index++) {
      for (final List<int> block in dataBlocks) {
        if (index < block.length) result.add(block[index]);
      }
    }
    for (int index = 0; index < maxEcLength; index++) {
      for (final List<int> block in ecBlocks) {
        if (index < block.length) result.add(block[index]);
      }
    }
    return result;
  }

  /// Codewords de corrección de un bloque (polinomio generador en GF(256)).
  List<int> _reedSolomon(List<int> data, int ecLength) {
    final List<int> generator = _generatorPolynomial(ecLength);
    final List<int> remainder = List<int>.filled(ecLength, 0);
    for (final int byte in data) {
      final int factor = byte ^ remainder[0];
      remainder.removeAt(0);
      remainder.add(0);
      for (int index = 0; index < ecLength; index++) {
        remainder[index] ^= _multiply(generator[index], factor);
      }
    }
    return remainder;
  }

  List<int> _generatorPolynomial(int degree) {
    List<int> polynomial = <int>[1];
    for (int index = 0; index < degree; index++) {
      final List<int> next = List<int>.filled(polynomial.length + 1, 0);
      for (int position = 0; position < polynomial.length; position++) {
        next[position] ^= polynomial[position];
        next[position + 1] ^= _multiply(polynomial[position], _exp[index]);
      }
      polynomial = next;
    }
    // El coeficiente líder siempre es 1 y no se usa en el cálculo.
    return polynomial.sublist(1);
  }

  static int _multiply(int left, int right) {
    if (left == 0 || right == 0) return 0;
    return _exp[_log[left] + _log[right]];
  }
}

/// Acumulador de bits usado al construir el mensaje.
final class _BitBuffer {
  final List<int> _bits = <int>[];

  int get length => _bits.length;

  void append(int value, int bitCount) {
    for (int index = bitCount - 1; index >= 0; index--) {
      _bits.add((value >> index) & 1);
    }
  }

  List<int> get bytes {
    final List<int> result = List<int>.filled(_bits.length ~/ 8, 0);
    for (int index = 0; index < _bits.length; index++) {
      if (_bits[index] == 1) result[index >> 3] |= 0x80 >> (index & 7);
    }
    return result;
  }
}

/// Construcción de la matriz de módulos, máscaras y evaluación.
final class _Matrix {
  _Matrix(this.version, [List<List<bool>>? modules, List<List<bool>>? functions])
      : size = version * 4 + 17,
        _modules = modules ??
            List<List<bool>>.generate(
              version * 4 + 17,
              (_) => List<bool>.filled(version * 4 + 17, false),
            ),
        _isFunction = functions ??
            List<List<bool>>.generate(
              version * 4 + 17,
              (_) => List<bool>.filled(version * 4 + 17, false),
            );

  final int version;
  final int size;
  final List<List<bool>> _modules;
  final List<List<bool>> _isFunction;

  static const int penaltyAdjacent = 3;
  static const int penaltyBlock = 3;
  static const int penaltyFinder = 40;
  static const int penaltyBalance = 10;
  static const List<int> _finderCore = <int>[1, 0, 1, 1, 1, 0, 1];

  _Matrix copy() => _Matrix(
        version,
        _modules.map((List<bool> row) => List<bool>.of(row)).toList(),
        _isFunction.map((List<bool> row) => List<bool>.of(row)).toList(),
      );

  List<List<bool>> snapshot() =>
      _modules.map((List<bool> row) => List<bool>.of(row)).toList();

  /// Marca un módulo como patrón de función (fuera de la región de datos).
  void _markFunction(int x, int y) => _isFunction[y][x] = true;

  void _set(int x, int y, bool dark) {
    _modules[y][x] = dark;
    _markFunction(x, y);
  }

  bool _module(int x, int y) => _modules[y][x];

  bool _isFunctionModule(int x, int y) => _isFunction[y][x];

  void drawFunctionPatterns() {
    for (int index = 0; index < size; index++) {
      _set(6, index, index % 2 == 0);
      _set(index, 6, index % 2 == 0);
    }
    _drawFinderPattern(3, 3);
    _drawFinderPattern(size - 4, 3);
    _drawFinderPattern(3, size - 4);

    if (version >= 2) {
      final List<int> positions = qrAlignmentPositions[version - 2];
      for (final int x in positions) {
        for (final int y in positions) {
          final bool overlapsFinder = (x == 6 && y == 6) ||
              (x == 6 && y == size - 7) ||
              (x == size - 7 && y == 6);
          if (!overlapsFinder) _drawAlignmentPattern(x, y);
        }
      }
    }
    _reserveFormatAreas();
    if (version >= 7) _reserveVersionAreas();
  }

  void _drawFinderPattern(int centerX, int centerY) {
    for (int dy = -4; dy <= 4; dy++) {
      for (int dx = -4; dx <= 4; dx++) {
        final int distance = math.max(dx.abs(), dy.abs());
        final int x = centerX + dx;
        final int y = centerY + dy;
        if (x >= 0 && x < size && y >= 0 && y < size) {
          _set(x, y, distance != 2 && distance != 4);
        }
      }
    }
  }

  void _drawAlignmentPattern(int centerX, int centerY) {
    for (int dy = -2; dy <= 2; dy++) {
      for (int dx = -2; dx <= 2; dx++) {
        _set(centerX + dx, centerY + dy, math.max(dx.abs(), dy.abs()) != 1);
      }
    }
  }

  /// Reserva las áreas de información de formato sin escribir sus valores.
  void _reserveFormatAreas() {
    for (int index = 0; index < 9; index++) {
      _markFunction(8, index);
      _markFunction(index, 8);
    }
    for (int index = 1; index < 9; index++) {
      _markFunction(8, size - index);
      _markFunction(size - index, 8);
    }
    _set(8, size - 8, true); // Módulo oscuro obligatorio.
  }

  void _reserveVersionAreas() {
    for (int index = 0; index < 6; index++) {
      for (int offset = 0; offset < 3; offset++) {
        _markFunction(size - 11 + offset, index);
        _markFunction(index, size - 11 + offset);
      }
    }
  }

  /// Coloca los codewords en zigzag desde la esquina inferior derecha.
  void drawCodewords(List<int> codewords) {
    final List<int> bits = <int>[];
    for (final int byte in codewords) {
      for (int index = 7; index >= 0; index--) {
        bits.add((byte >> index) & 1);
      }
    }
    int index = 0;
    for (int right = size - 1; right >= 1; right -= 2) {
      if (right == 6) right -= 1;
      for (int vertical = 0; vertical < size; vertical++) {
        for (int column = 0; column < 2; column++) {
          final int x = right - column;
          final bool upward = ((right & 2) == 0) ^ (x < 6);
          final int y = upward ? size - 1 - vertical : vertical;
          if (!_isFunctionModule(x, y) && index < bits.length) {
            _modules[y][x] = bits[index] == 1;
            index++;
          }
        }
      }
    }
    assert(index == bits.length, 'Módulos de datos insuficientes');
  }

  /// Aplica (o revierte) una máscara XOR sobre la región de datos.
  void applyMask(int mask) {
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (_isFunctionModule(x, y)) continue;
        if (_maskCondition(mask, x, y)) _modules[y][x] = !_modules[y][x];
      }
    }
  }

  static bool _maskCondition(int mask, int x, int y) => switch (mask) {
        0 => (x + y) % 2 == 0,
        1 => y % 2 == 0,
        2 => x % 3 == 0,
        3 => (x + y) % 3 == 0,
        4 => (x ~/ 3 + y ~/ 2) % 2 == 0,
        5 => x * y % 2 + x * y % 3 == 0,
        6 => (x * y % 2 + x * y % 3) % 2 == 0,
        7 => ((x + y) % 2 + x * y % 3) % 2 == 0,
        _ => false,
      };

  /// Información de formato en sus dos copias (bits 0..14).
  void writeFormatInfo(QrErrorCorrection level, int mask) {
    final int data = (level.formatBits << 3) | mask;
    int remainder = data;
    for (int index = 0; index < 10; index++) {
      remainder = (remainder << 1) ^ ((remainder >> 9) * 0x537);
    }
    final int bits = (data << 10 | remainder) ^ 0x5412;

    for (int index = 0; index < 6; index++) {
      _modules[index][8] = _bit(bits, index);
    }
    _modules[7][8] = _bit(bits, 6);
    _modules[8][8] = _bit(bits, 7);
    _modules[8][7] = _bit(bits, 8);
    for (int index = 9; index < 15; index++) {
      _modules[8][14 - index] = _bit(bits, index);
    }
    for (int index = 0; index < 8; index++) {
      _modules[8][size - 1 - index] = _bit(bits, index);
    }
    for (int index = 8; index < 15; index++) {
      _modules[size - 15 + index][8] = _bit(bits, index);
    }
    _modules[size - 8][8] = true;
  }

  /// Información de versión (solo versiones 7 o superiores).
  void writeVersionInfo() {
    if (version < 7) return;
    int remainder = version;
    for (int index = 0; index < 12; index++) {
      remainder = (remainder << 1) ^ ((remainder >> 11) * 0x1F25);
    }
    final int bits = version << 12 | remainder;
    for (int index = 0; index < 18; index++) {
      final bool dark = _bit(bits, index);
      final int first = size - 11 + index % 3;
      final int second = index ~/ 3;
      _modules[second][first] = dark;
      _modules[first][second] = dark;
    }
  }

  static bool _bit(int value, int index) => ((value >> index) & 1) != 0;

  /// Penalización total de la máscara (reglas N1 a N4, ISO/IEC 18004 7.8.3).
  int penaltyScore() =>
      _penaltyAdjacentModules() +
      _penaltyBlocks() +
      _penaltyFinderPatterns() +
      _penaltyBalance();

  /// N1: 3 puntos por cada grupo de 5 módulos iguales y 1 más por cada
  /// módulo adicional (equivalente a `longitud - 2`).
  int _penaltyAdjacentModules() {
    int penalty = 0;
    for (int index = 0; index < size; index++) {
      penalty += _linePenaltyN1(
        List<bool>.generate(size, (int x) => _module(x, index)),
      );
      penalty += _linePenaltyN1(
        List<bool>.generate(size, (int y) => _module(index, y)),
      );
    }
    return penalty;
  }

  static int _linePenaltyN1(List<bool> line) {
    int penalty = 0;
    bool? previous;
    int runLength = 0;
    for (final bool module in line) {
      if (module == previous) {
        runLength++;
      } else {
        if (runLength >= 5) penalty += runLength - 2;
        runLength = 1;
      }
      previous = module;
    }
    if (runLength >= 5) penalty += runLength - 2;
    return penalty;
  }

  /// N2: 3 puntos por cada bloque 2x2 del mismo color.
  int _penaltyBlocks() {
    int penalty = 0;
    for (int y = 1; y < size; y++) {
      for (int x = 1; x < size; x++) {
        final bool value = _module(x, y);
        if (value == _module(x - 1, y) &&
            value == _module(x, y - 1) &&
            value == _module(x - 1, y - 1)) {
          penalty += penaltyBlock;
        }
      }
    }
    return penalty;
  }

  /// N3: 40 puntos por cada patrón 1:1:3:1:1 rodeado (o precedido/seguido)
  /// por cuatro módulos claros.
  int _penaltyFinderPatterns() {
    int penalty = 0;
    for (int index = 0; index < size; index++) {
      penalty += _linePenaltyN3(
        List<bool>.generate(size, (int x) => _module(x, index)),
      );
      penalty += _linePenaltyN3(
        List<bool>.generate(size, (int y) => _module(index, y)),
      );
    }
    return penalty;
  }

  int _linePenaltyN3(List<bool> line) {
    int penalty = 0;
    int start = 0;
    while (true) {
      final int index = _findPattern(line, start);
      if (index == -1) break;
      int next = index + 7;
      final bool atEdge = index == 0 || index == size - 7;
      final bool clearBefore = _allLight(line, math.max(index - 4, 0), index);
      final bool clearAfter =
          _allLight(line, next, math.min(next + 4, size));
      if (atEdge || clearBefore || clearAfter) {
        penalty += penaltyFinder;
      } else {
        next = index + 4;
      }
      start = next;
    }
    return penalty;
  }

  int _findPattern(List<bool> line, int start) {
    for (int index = start;
        index + _finderCore.length <= line.length;
        index++) {
      bool matches = true;
      for (int offset = 0; offset < _finderCore.length; offset++) {
        final bool expected = _finderCore[offset] == 1;
        if (line[index + offset] != expected) {
          matches = false;
          break;
        }
      }
      if (matches) return index;
    }
    return -1;
  }

  bool _allLight(List<bool> line, int start, int end) {
    for (int index = start; index < end; index++) {
      if (line[index]) return false;
    }
    return true;
  }

  /// N4: 10 puntos por cada 5 % de desviación respecto al 50 % de módulos
  /// oscuros.
  int _penaltyBalance() {
    int dark = 0;
    for (final List<bool> row in _modules) {
      for (final bool module in row) {
        if (module) dark++;
      }
    }
    final int total = size * size;
    final double percent = dark / total;
    final int steps = ((percent * 100 - 50).abs() / 5).floor();
    return steps * penaltyBalance;
  }
}
