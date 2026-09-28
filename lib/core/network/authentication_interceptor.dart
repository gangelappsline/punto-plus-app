import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

final class AuthenticationInterceptor extends QueuedInterceptor {
  AuthenticationInterceptor({
    required Dio client,
    required Dio refreshClient,
    required TokenStorage tokenStorage,
    required String refreshPath,
    required Set<String> publicPaths,
  })  : _client = client,
        _refreshClient = refreshClient,
        _tokenStorage = tokenStorage,
        _refreshPath = refreshPath,
        _publicPaths = publicPaths;

  final Dio _client;
  final Dio _refreshClient;
  final TokenStorage _tokenStorage;
  final String _refreshPath;
  final Set<String> _publicPaths;

  static const String _retriedKey = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_publicPaths.contains(options.path)) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    final canRefresh = error.response?.statusCode == 401 &&
        !_publicPaths.contains(request.path) &&
        request.extra[_retriedKey] != true;

    if (!canRefresh) {
      handler.next(error);
      return;
    }

    try {
      final currentAccessToken = await _tokenStorage.readAccessToken();
      final tokenUsed = request.headers['Authorization']?.toString();
      String? accessToken = currentAccessToken;

      // A queued request might have failed with an old token while another
      // request had already refreshed it. In that case, just retry.
      if (currentAccessToken == null ||
          tokenUsed == 'Bearer $currentAccessToken') {
        final refreshToken = await _tokenStorage.readRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          await _tokenStorage.clear();
          handler.next(error);
          return;
        }

        final response = await _refreshClient.post<Map<String, dynamic>>(
          _refreshPath,
          data: <String, dynamic>{'refresh_token': refreshToken},
        );
        final body = _unwrap(response.data);
        accessToken = (body['access_token'] ?? body['accessToken'])?.toString();
        if (accessToken == null || accessToken.isEmpty) {
          throw const FormatException('Missing access token');
        }
        final newRefreshToken =
            (body['refresh_token'] ?? body['refreshToken'])?.toString();
        final expiresIn = int.tryParse(
          (body['expires_in'] ?? body['expiresIn'] ?? '').toString(),
        );
        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: newRefreshToken ?? refreshToken,
          expiresAt: expiresIn == null
              ? null
              : DateTime.now().add(Duration(seconds: expiresIn)),
        );
      }

      request.extra[_retriedKey] = true;
      request.headers['Authorization'] = 'Bearer $accessToken';
      final response = await _client.fetch<dynamic>(request);
      handler.resolve(response);
    } on Object {
      await _tokenStorage.clear();
      handler.next(error);
    }
  }

  static Map<String, dynamic> _unwrap(Map<String, dynamic>? response) {
    if (response == null) return <String, dynamic>{};
    final data = response['data'];
    return data is Map<String, dynamic> ? data : response;
  }
}
