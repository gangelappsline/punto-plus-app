import '../network/api_response.dart';

/// Lista paginada devuelta por Laravel (`data` + `meta`).
final class Paginated<T> {
  const Paginated({
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.perPage = 20,
  });

  /// Interpreta respuestas con `meta` de Laravel, `pagination` o listas simples.
  factory Paginated.fromJson(
    dynamic body,
    T Function(Map<String, dynamic> json) parse, {
    int fallbackPerPage = 20,
  }) {
    final Map<String, dynamic> map =
        body is Map ? ApiResponse.asMap(body) : <String, dynamic>{};
    final Map<String, dynamic> meta = _metaOf(map) ?? <String, dynamic>{};
    final List<Map<String, dynamic>> rawItems = ApiResponse.asList(body);

    return Paginated<T>(
      items: rawItems.map(parse).toList(),
      currentPage: _intOf(meta, <String>['current_page', 'page']) ?? 1,
      lastPage: _intOf(meta, <String>['last_page', 'total_pages']) ??
          (rawItems.isEmpty ? 1 : 1),
      total: _intOf(meta, <String>['total']) ?? rawItems.length,
      perPage: _intOf(meta, <String>['per_page']) ?? fallbackPerPage,
    );
  }

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  bool get hasMore => currentPage < lastPage;

  Paginated<T> copyWith({List<T>? items, int? currentPage}) => Paginated<T>(
        items: items ?? this.items,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage,
        total: total,
        perPage: perPage,
      );

  static Map<String, dynamic>? _metaOf(Map<String, dynamic> map) {
    final dynamic meta = map['meta'] ?? map['pagination'];
    if (meta is Map<String, dynamic>) return meta;
    if (meta is Map) return ApiResponse.asMap(meta);
    return null;
  }

  static int? _intOf(Map<String, dynamic> map, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = map[key];
      if (value != null) {
        final int? parsed = int.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}
