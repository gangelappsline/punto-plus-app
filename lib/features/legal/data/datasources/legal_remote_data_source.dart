import 'package:dio/dio.dart';

import '../../../../core/config/api_paths.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_response.dart';
import '../models/legal_document.dart';

/// Descarga de documentos legales publicados por el backend.
final class LegalRemoteDataSource {
  const LegalRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LegalDocument> fetchTerms() =>
      _fetch(ApiPaths.terms, fallbackTitle: 'Términos y condiciones');

  Future<LegalDocument> fetchPrivacy() =>
      _fetch(ApiPaths.privacy, fallbackTitle: 'Política de privacidad');

  Future<LegalDocument> _fetch(
    String path, {
    required String fallbackTitle,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        options: Options(responseType: ResponseType.json),
      );
      final dynamic data = response.data;
      if (data is String) {
        return LegalDocument(title: fallbackTitle, content: data);
      }
      return LegalDocument.fromJson(
        ApiResponse.asMap(data),
        fallbackTitle: fallbackTitle,
      );
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
