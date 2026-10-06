import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'network_monitor.dart';

/// Registra cada petición en modo debug (nunca en producción).
final class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '← ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✗ ${error.response?.statusCode ?? error.type.name} '
        '${error.requestOptions.uri}',
      );
    }
    handler.next(error);
  }
}

/// Mantiene actualizado el [NetworkMonitor] con cada resultado de red.
final class NetworkStatusInterceptor extends Interceptor {
  NetworkStatusInterceptor(this._monitor);

  final NetworkMonitor _monitor;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _monitor.reportSuccess();
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _monitor.reportFailure(error);
    handler.next(error);
  }
}
