import 'package:dio/dio.dart';

import '../config/api_paths.dart';
import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'api_interceptors.dart';
import 'authentication_interceptor.dart';
import 'network_monitor.dart';

/// Cliente HTTP configurado con autenticación, refresco de token y auditoría.
final class ApiClient {
  ApiClient({
    required AppConfig config,
    required TokenStorage tokenStorage,
    NetworkMonitor? networkMonitor,
  }) {
    final BaseOptions options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.connectTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: const <String, dynamic>{
        'Accept': Headers.jsonContentType,
        'Accept-Language': 'es-MX',
      },
    );

    dio = Dio(options);
    final Dio refreshDio = Dio(options);
    dio.interceptors.addAll(<Interceptor>[
      AuthenticationInterceptor(
        client: dio,
        refreshClient: refreshDio,
        tokenStorage: tokenStorage,
        refreshPath: ApiPaths.refresh,
        publicPaths: ApiPaths.publicPaths,
      ),
      NetworkStatusInterceptor(networkMonitor ?? NetworkMonitor()),
      LoggingInterceptor(),
    ]);
  }

  late final Dio dio;
}
