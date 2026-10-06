/// Lectura tolerante de JSON: acepta `snake_case` y `camelCase`, valores
/// nulos y tipos mixtos devueltos por la API.
abstract final class Json {
  static String text(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final String parsed = value.toString();
    return parsed;
  }

  static String? textOrNull(dynamic value) {
    if (value == null) return null;
    final String parsed = value.toString();
    return parsed.isEmpty ? null : parsed;
  }

  /// Primer valor no vacío entre varias claves.
  static dynamic pick(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = json[key];
      if (value != null) return value;
    }
    return null;
  }

  static int integer(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is double) return value.round();
    final int? parsed = int.tryParse(value?.toString() ?? '');
    if (parsed != null) return parsed;
    final double? asDouble = double.tryParse(value?.toString() ?? '');
    return asDouble?.round() ?? fallback;
  }

  static int? integerOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value.toString());
  }

  static double decimal(dynamic value, {double fallback = 0}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double? decimalOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static bool boolean(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final String text = value?.toString().toLowerCase() ?? '';
    if (text == 'true' || text == '1' || text == 'yes' || text == 'si') {
      return true;
    }
    if (text == 'false' || text == '0' || text == 'no') return false;
    return fallback;
  }

  static DateTime? dateTimeOrNull(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final int? milliseconds = int.tryParse(value.toString());
    if (milliseconds != null && milliseconds > 1000000000) {
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }
    return DateTime.tryParse(value.toString());
  }

  static DateTime? dateOnlyOrNull(dynamic value) {
    final DateTime? parsed = dateTimeOrNull(value);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  /// Convierte una lista de cualquier tipo en lista de mapas.
  static List<Map<String, dynamic>> maps(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];
    return value
        .map(mapOrNull)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Convierte listas de cadenas (galería, categorías) en `List<String>`.
  static List<String> strings(dynamic value) {
    if (value is String) {
      return value.isEmpty ? <String>[] : <String>[value];
    }
    if (value is! List) return <String>[];
    return value
        .map((dynamic item) => item?.toString() ?? '')
        .where((String item) => item.isNotEmpty)
        .toList();
  }

  /// Devuelve un mapa normalizado con claves `String`.
  static Map<String, dynamic> map(dynamic value) =>
      mapOrNull(value) ?? <String, dynamic>{};

  static Map<String, dynamic>? mapOrNull(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map<String, dynamic>(
        (dynamic key, dynamic item) =>
            MapEntry<String, dynamic>(key.toString(), item),
      );
    }
    if (value is String && value.isNotEmpty) {
      return <String, dynamic>{'value': value};
    }
    return null;
  }
}
