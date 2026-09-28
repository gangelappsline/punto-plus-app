import 'package:dio/dio.dart';

final class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.statusCode,
    this.fieldErrors = const <String, String>{},
  });

  factory AppException.fromDio(DioException error) {
    final response = error.response;
    final data = response?.data;
    String? code;
    String? apiMessage;
    final fieldErrors = <String, String>{};

    if (data is Map<String, dynamic>) {
      code = data['code']?.toString();
      apiMessage = (data['message'] ?? data['error'])?.toString();
      final errors = data['errors'];
      if (errors is Map) {
        for (final entry in errors.entries) {
          final value = entry.value;
          fieldErrors[entry.key.toString()] =
              value is List && value.isNotEmpty ? value.first.toString() : value.toString();
        }
      }
    }

    return AppException(
      message: apiMessage ?? _fallbackMessage(error),
      code: code,
      statusCode: response?.statusCode,
      fieldErrors: fieldErrors,
    );
  }

  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  static String _fallbackMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La conexión tardó demasiado. Inténtalo de nuevo.';
      case DioExceptionType.connectionError:
        return 'No pudimos conectarnos. Revisa tu conexión a internet.';
      case DioExceptionType.cancel:
        return 'La solicitud fue cancelada.';
      case DioExceptionType.badCertificate:
        return 'No se pudo validar la conexión segura.';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return 'Tus datos de acceso no son correctos.';
        }
        if (error.response?.statusCode == 429) {
          return 'Demasiados intentos. Espera un momento.';
        }
        return 'No pudimos completar la solicitud.';
      case DioExceptionType.unknown:
        return 'Ocurrió un error inesperado. Inténtalo de nuevo.';
    }
  }

  @override
  String toString() => message;
}
