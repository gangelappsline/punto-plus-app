/// Utilidades para interpretar respuestas de la API.
///
/// El backend puede responder el recurso en la raíz o envuelto en `data`.
abstract final class ApiResponse {
  /// Devuelve el mapa principal de la respuesta.
  static Map<String, dynamic> asMap(dynamic body) {
    if (body is Map<String, dynamic>) {
      final dynamic data = body['data'];
      if (data is Map<String, dynamic>) return data;
      return body;
    }
    if (body is Map) {
      final Map<String, dynamic> mapped = <String, dynamic>{};
      body.forEach((dynamic key, dynamic value) {
        mapped[key.toString()] = value;
      });
      final dynamic data = mapped['data'];
      if (data is Map) return asMap(data);
      return mapped;
    }
    return <String, dynamic>{};
  }

  /// Devuelve la lista principal de la respuesta.
  static List<Map<String, dynamic>> asList(dynamic body) {
    dynamic payload = body;
    if (payload is Map) {
      final dynamic data = payload['data'];
      if (data != null) payload = data;
    }
    if (payload is! List) return <Map<String, dynamic>>[];
    return payload
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (Map<dynamic, dynamic> item) => item.map<String, dynamic>(
            (dynamic key, dynamic value) => MapEntry<String, dynamic>(
              key.toString(),
              value,
            ),
          ),
        )
        .toList();
  }

  /// Texto de una respuesta que no es JSON (por ejemplo HTML de términos).
  static String asText(dynamic body) {
    if (body == null) return '';
    if (body is String) return body;
    if (body is Map) {
      final dynamic data = body['data'] ?? body['content'] ?? body['body'];
      if (data != null && data is String) return data;
    }
    return body.toString();
  }
}
