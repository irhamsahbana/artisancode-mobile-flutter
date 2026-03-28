class AppConfig {
  static const String defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3939',
  );
}
