/// Valores de configuración inyectados en tiempo de compilación con
/// `--dart-define`.
final class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.environment,
    required this.googleMapsApiKey,
    required this.supportEmail,
    required this.websiteUrl,
    required this.pageSize,
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
        apiBaseUrl: String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.punto-plus.com.mx/api',
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
        environment: String.fromEnvironment('ENV', defaultValue: 'dev'),
        googleMapsApiKey: String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
        supportEmail: 'soporte@punto-plus.com.mx',
        websiteUrl: 'https://punto-plus.com.mx',
        pageSize: 20,
      );

  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// `dev`, `staging` o `prod`.
  final String environment;

  /// Clave de Google Maps leída en tiempo de compilación.
  ///
  /// La app funciona sin ella usando la vista esquemática del mapa; al
  /// integrar `google_maps_flutter` esta clave se pasa al SDK nativo.
  final String googleMapsApiKey;
  final String supportEmail;
  final String websiteUrl;
  final int pageSize;

  bool get isProduction => environment == 'prod';

  bool get hasMapsKey => googleMapsApiKey.isNotEmpty;

  static const String apiBaseUrlKey = 'API_BASE_URL';
  static const String environmentKey = 'ENV';
  static const String mapsKey = 'GOOGLE_MAPS_API_KEY';
}
