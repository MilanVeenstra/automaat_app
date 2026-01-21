/// API configuration constants
abstract class ApiConfig {
  /// Base URL for the backend API
  /// Use 10.0.2.2 for Android emulator (refers to host machine)
  /// Use localhost for web/desktop
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Auth endpoints
  static const String login = '/api/authenticate';
  static const String register = '/api/AM/register';
  static const String me = '/api/AM/me';
  static const String resetPasswordInit = '/api/account/reset-password/init';
  static const String resetPasswordFinish = '/api/account/reset-password/finish';
}
