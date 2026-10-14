/// Public build configuration, never a place for server secrets.
class AppConfig {
  const AppConfig();

  static const demo = bool.fromEnvironment('DEMO_MODE', defaultValue: true);
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.punto-plus.com.mx/api',
  );
  // The native Maps SDK keys must ALSO be configured; see README.
  static const mapsEnabled = bool.fromEnvironment('MAPS_ENABLED');
  static const connectTimeout = int.fromEnvironment(
    'API_CONNECT_TIMEOUT_SECONDS',
    defaultValue: 20,
  );
  static const receiveTimeout = int.fromEnvironment(
    'API_RECEIVE_TIMEOUT_SECONDS',
    defaultValue: 20,
  );
}
