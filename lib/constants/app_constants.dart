/// Application-wide constants.
class AppConstants {
  AppConstants._();

  /// Base URL for the TaoPulse API.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://apps.cognia.solutions/taopulse',
  );
}
