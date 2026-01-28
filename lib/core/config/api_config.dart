/// API configuration constants
abstract class ApiConfig {
  /// Basis URL voor de backend API
  /// Gebruik 10.0.2.2 voor Android emulator (verwijst naar host machine)
  /// Gebruik localhost voor web/desktop
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Auth endpoints
  static const String login = '/api/authenticate';
  static const String register = '/api/AM/register';
  static const String me = '/api/AM/me';
  static const String resetPasswordInit = '/api/account/reset-password/init';
  static const String resetPasswordFinish = '/api/account/reset-password/finish';

  // Auto endpoints
  static const String cars = '/api/cars';
  static String carById(int id) => '/api/cars/$id';

  // Verhuur endpoints
  static const String rentals = '/api/rentals';
  static String rentalById(int id) => '/api/rentals/$id';

  // Inspecties (Schade Rapporten) endpoints
  static const String inspections = '/api/inspections';
  static String inspectionById(int id) => '/api/inspections/$id';
  static const String inspectionPhotos = '/api/inspection-photos';
}
