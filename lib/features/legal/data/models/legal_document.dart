import '../../../../core/utils/json.dart';

/// Documento legal (términos, privacidad) con contenido HTML o texto.
final class LegalDocument {
  const LegalDocument({
    required this.title,
    required this.content,
    this.updatedAt,
  });

  factory LegalDocument.fromJson(
    Map<String, dynamic> json, {
    String fallbackTitle = '',
  }) =>
      LegalDocument(
        title: Json.text(
          Json.pick(json, <String>['title', 'name']),
          fallback: fallbackTitle,
        ),
        content: Json.text(
          Json.pick(json, <String>['content', 'body', 'html', 'text']),
        ),
        updatedAt: Json.dateTimeOrNull(
          Json.pick(json, <String>['updated_at', 'updatedAt', 'published_at']),
        ),
      );

  final String title;
  final String content;
  final DateTime? updatedAt;

  bool get isEmpty => content.trim().isEmpty;
}
