import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_store.dart';
import 'app_failure.dart';

/// Infrastructure only. No undocumented endpoint or refresh flow is assumed.
Dio createApiClient({
  required TokenStore tokens,
  required void Function() onUnauthorized,
}) {
  final base = Uri.parse(AppConfig.apiBaseUrl);
  if (base.scheme != 'https' || base.host.isEmpty) {
    throw const AppFailure('La API debe usar una URL HTTPS válida.');
  }
  final dio = Dio(BaseOptions(
    baseUrl: base.toString(),
    connectTimeout: Duration(seconds: AppConfig.connectTimeout),
    receiveTimeout: Duration(seconds: AppConfig.receiveTimeout),
    sendTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
    // Do not follow cross-origin redirects with credentials.
    followRedirects: false,
  ));
  dio.interceptors.add(QueuedInterceptorsWrapper(
    onRequest: (options, handler) async {
      try {
        if (options.uri.origin != base.origin) {
          handler.reject(DioException(
            requestOptions: options,
            error: const AppFailure('Origen de API no permitido.'),
          ));
          return;
        }
        final token = await tokens.read();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      } on Object {
        handler.reject(DioException(
          requestOptions: options,
          error: const AppFailure('No se pudo acceder a la sesión segura.'),
        ));
      }
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        // Ignore a late 401 belonging to an already-replaced token.
        try {
          final current = await tokens.read();
          if (current != null &&
              error.requestOptions.headers['Authorization'] ==
                  'Bearer $current') {
            await tokens.clear();
            onUnauthorized();
          }
        } on Object {
          onUnauthorized();
        }
      }
      // Never retry purchases/canjes automatically.
      handler.next(error.copyWith(error: mapNetworkFailure(error)));
    },
  ));
  return dio;
}

AppFailure mapNetworkFailure(DioException error) {
  if (error.error is AppFailure) {
    return error.error! as AppFailure;
  }
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionError) {
    return const AppFailure(
        'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.');
  }
  return switch (error.response?.statusCode) {
    401 => const AppFailure('Tu sesión expiró. Inicia sesión de nuevo.'),
    403 => const AppFailure('No tienes permiso para realizar esta acción.'),
    409 =>
      const AppFailure('Esta operación ya se procesó o los datos cambiaron.'),
    422 => const AppFailure('Revisa los datos ingresados.'),
    429 => const AppFailure('Demasiados intentos. Espera un momento.'),
    _ =>
      const AppFailure('El servicio no está disponible. Inténtalo más tarde.'),
  };
}
