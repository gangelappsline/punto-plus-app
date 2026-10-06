import 'package:dio/dio.dart';

/// Error de aplicación con mensaje listo para mostrar al usuario.
final class AppException implements Exception {
  const AppException({
    required this.message,
    this.messageKey,
    this.code,
    this.statusCode,
    this.fieldErrors = const <String, String>{},
  });

  /// Crea un error ya localizable a partir de una clave del catálogo.
  factory AppException.localized(
    String messageKey, {
    String? message,
    String? code,
    int? statusCode,
    Map<String, String> fieldErrors = const <String, String>{},
  }) =>
      AppException(
        message: message ?? messageKey,
        messageKey: messageKey,
        code: code,
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );

  factory AppException.fromDio(DioException error) {
    final Response<dynamic>? response = error.response;
    final dynamic data = response?.data;
    String? code;
    String? apiMessage;
    final Map<String, String> fieldErrors = <String, String>{};

    if (data is Map) {
      code = data['code']?.toString();
      apiMessage = (data['message'] ?? data['error'])?.toString();
      final dynamic errors = data['errors'];
      if (errors is Map) {
        for (final MapEntry<dynamic, dynamic> entry in errors.entries) {
          final dynamic value = entry.value;
          fieldErrors[entry.key.toString()] = value is List && value.isNotEmpty
              ? value.first.toString()
              : value.toString();
        }
        if (apiMessage == null && fieldErrors.isNotEmpty) {
          apiMessage = fieldErrors.values.first;
        }
      }
    }

    // Cuando la API no explica el error usamos una clave traducida.
    final bool hasApiMessage = apiMessage != null && apiMessage.isNotEmpty;
    return AppException(
      message: hasApiMessage ? apiMessage : _fallbackMessage(error),
      messageKey: hasApiMessage ? null : _fallbackKey(error),
      code: code,
      statusCode: response?.statusCode,
      fieldErrors: fieldErrors,
    );
  }

  /// Normaliza cualquier objeto lanzado a un [AppException].
  factory AppException.fromObject(Object error) {
    if (error is AppException) return error;
    if (error is DioException) return AppException.fromDio(error);
    return AppException(message: error.toString());
  }

  final String message;

  /// Clave del catálogo de textos (`l10n/strings.json`) cuando el mensaje es
  /// propio de la app; `null` si la API ya devolvió un texto para el usuario.
  final String? messageKey;

  final String? code;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isValidationError => statusCode == 422;

  bool get isRateLimited => statusCode == 429;

  bool get isServerError => statusCode != null && statusCode! >= 500;

  bool get isMaintenance => statusCode == 503;

  bool get isConnectionError =>
      statusCode == null &&
      (code == null || code == 'connection_error' || code == 'timeout');

  /// Clave de traducción equivalente al mensaje de respaldo.
  static String _fallbackKey(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'errors.timeout';
      case DioExceptionType.connectionError:
        return 'errors.connection';
      case DioExceptionType.cancel:
        return 'errors.cancelled';
      case DioExceptionType.badCertificate:
        return 'errors.secure_connection';
      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'errors.unauthorized';
        if (statusCode == 403) return 'errors.forbidden';
        if (statusCode == 404) return 'errors.not_found';
        if (statusCode == 422) return 'errors.validation_failed';
        if (statusCode == 429) return 'errors.rate_limited';
        if (statusCode == 503) return 'errors.maintenance_message';
        if (statusCode != null && statusCode >= 500) return 'errors.server';
        return 'errors.request_failed';
      case DioExceptionType.unknown:
        return 'errors.unexpected';
    }
  }

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
        final int? statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'Tus datos de acceso no son correctos.';
        if (statusCode == 403) {
          return 'Tu cuenta no tiene permisos para esta acción.';
        }
        if (statusCode == 404) return 'No encontramos la información.';
        if (statusCode == 422) return 'Revisa los datos del formulario.';
        if (statusCode == 429) {
          return 'Demasiados intentos. Espera un momento.';
        }
        if (statusCode != null && statusCode >= 500) {
          return 'Tuvimos un problema en el servidor. Inténtalo más tarde.';
        }
        return 'No pudimos completar la solicitud.';
      case DioExceptionType.unknown:
        return 'Ocurrió un error inesperado. Inténtalo de nuevo.';
    }
  }

  @override
  String toString() => message;
}
