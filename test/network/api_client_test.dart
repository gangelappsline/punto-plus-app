import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punto_plus_app/core/network/api_client.dart';
import 'package:punto_plus_app/core/storage/token_store.dart';

class MemoryTokens implements TokenStore {
  String? token = 'example-token';
  @override
  Future<String?> read() async => token;
  @override
  Future<void> write(String value) async {
    token = value;
  }

  @override
  Future<void> clear() async {
    token = null;
  }
}

class StubAdapter implements HttpClientAdapter {
  StubAdapter(this.status);
  final int status;
  RequestOptions? lastRequest;
  int requests = 0;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests++;
    lastRequest = options;
    return ResponseBody.fromString('{}', status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('adds bearer token on the configured origin only', () async {
    final tokens = MemoryTokens();
    final dio = createApiClient(tokens: tokens, onUnauthorized: () {});
    addTearDown(() => dio.close(force: true));
    final adapter = StubAdapter(200);
    dio.httpClientAdapter = adapter;
    await dio.get<dynamic>('/contract-test-only');
    expect(
        adapter.lastRequest!.headers['Authorization'], 'Bearer example-token');
    await expectLater(dio.get<dynamic>('https://untrusted.example/steal'),
        throwsA(isA<DioException>()));
    expect(adapter.requests, 1);
  });

  test('401 clears the token and emits session expiration without retries',
      () async {
    final tokens = MemoryTokens();
    var expired = 0;
    final dio =
        createApiClient(tokens: tokens, onUnauthorized: () => expired++);
    addTearDown(() => dio.close(force: true));
    final adapter = StubAdapter(401);
    dio.httpClientAdapter = adapter;
    await expectLater(
        dio.post<dynamic>('/contract-test-only'), throwsA(isA<DioException>()));
    expect(tokens.token, isNull);
    expect(expired, 1);
    expect(adapter.requests, 1);
  });
}
