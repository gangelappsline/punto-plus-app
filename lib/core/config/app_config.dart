/// Configuration values supplied at build/run time with `--dart-define`.
final class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
        apiBaseUrl: String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.example.com/v1',
        ),
        connectTimeout: Duration(
          seconds: int.fromEnvironment(
            'API_CONNECT_TIMEOUT_SECONDS',
            defaultValue: 20,
          ),
        ),
        receiveTimeout: Duration(
          seconds: int.fromEnvironment(
            'API_RECEIVE_TIMEOUT_SECONDS',
            defaultValue: 20,
          ),
        ),
      );

  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  static const String apiBaseUrlKey = 'API_BASE_URL';
}
