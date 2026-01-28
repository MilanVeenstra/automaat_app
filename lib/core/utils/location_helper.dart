import 'package:geolocator/geolocator.dart';

import '../config/app_constants.dart';

/// Helper class voor locatie functionaliteit
class LocationHelper {
  /// Haal huidige GPS locatie op, gebruik fallback als GPS niet beschikbaar is
  /// Retourneert latitude, longitude en boolean die aangeeft of fallback gebruikt is
  static Future<LocationResult> getCurrentLocationOrFallback() async {
    try {
      // Controleer locatie permissies
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          // Permissie geweigerd, gebruik fallback
          return LocationResult(
            latitude: AppConstants.fallbackLatitude,
            longitude: AppConstants.fallbackLongitude,
            isFallback: true,
          );
        }
      }

      // Probeer GPS locatie op te halen
      final position = await Geolocator.getCurrentPosition();
      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        isFallback: false,
      );
    } catch (e) {
      // GPS fout, gebruik fallback locatie
      return LocationResult(
        latitude: AppConstants.fallbackLatitude,
        longitude: AppConstants.fallbackLongitude,
        isFallback: true,
      );
    }
  }
}

/// Resultaat van locatie opvraag
class LocationResult {
  final double latitude;
  final double longitude;
  final bool isFallback;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.isFallback,
  });
}
