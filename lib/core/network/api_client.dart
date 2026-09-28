import 'package:dio/dio.dart';

import '../config/api_paths.dart';
import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'authentication_interceptor.dart';

final class ApiClient {
  ApiClient({
    required AppConfig config,
    required TokenStorage tokenStorage,
  }) {
    final options = BaseOptions(
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
    final refreshDio = Dio(options);
    dio.interceptors.add(
      AuthenticationInterceptor(
        client: dio,
        refreshClient: refreshDio,
        tokenStorage: tokenStorage,
        refreshPath: ApiPaths.refresh,
        publicPaths: const <String>{
          ApiPaths.login,
          ApiPaths.register,
          ApiPaths.refresh,
          ApiPaths.forgotPassword,
          ApiPaths.google,
          ApiPaths.apple,
        },
      ),
    );
  }

  late final Dio dio;
}
