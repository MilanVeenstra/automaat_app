abstract class AppConstants {
  /// Fallback locatie (Rotterdam centrum) voor wanneer GPS niet beschikbaar is
  /// Gebruikt bij het starten/beëindigen van verhuur zonder GPS signaal
  static const double fallbackLatitude = 51.9244;
  static const double fallbackLongitude = 4.4777;

  /// Fallback locatie naam voor gebruiker feedback
  static const String fallbackLocationName = 'Rotterdam centrum';
}
