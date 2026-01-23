import 'dart:math';

/// Car entity representing a rental car
class Car {
  final int id;
  final String brand;
  final String model;
  final String? picture; // base64 encoded image
  final CarFuel fuel;
  final String licensePlate;
  final double engineSize;
  final int modelYear;
  final double price; // rental price per day
  final int nrOfSeats;
  final CarBody body;
  final double? longitude;
  final double? latitude;

  const Car({
    required this.id,
    required this.brand,
    required this.model,
    this.picture,
    required this.fuel,
    required this.licensePlate,
    required this.engineSize,
    required this.modelYear,
    required this.price,
    required this.nrOfSeats,
    required this.body,
    this.longitude,
    this.latitude,
  });

  /// Calculate distance from given coordinates (in km)
  double? distanceFrom(double userLat, double userLon) {
    if (latitude == null || longitude == null) return null;

    // Haversine formula
    const double earthRadius = 6371; // km
    final double dLat = _toRadians(latitude! - userLat);
    final double dLon = _toRadians(longitude! - userLon);

    final double a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(userLat)) *
            _cos(_toRadians(latitude!)) *
            _sin(dLon / 2) *
            _sin(dLon / 2);

    final double c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * (3.14159265359 / 180);
  double _sin(double radians) => sin(radians);
  double _cos(double radians) => cos(radians);
  double _atan2(double y, double x) => atan2(y, x);
  double _sqrt(double value) => sqrt(value);
}

/// Car fuel type enum
enum CarFuel {
  gasoline('GASOLINE'),
  diesel('DIESEL'),
  hybrid('HYBRID'),
  electric('ELECTRIC');

  final String value;
  const CarFuel(this.value);

  static CarFuel fromString(String value) {
    return CarFuel.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => CarFuel.gasoline,
    );
  }

  String get displayName {
    switch (this) {
      case CarFuel.gasoline:
        return 'Gasoline';
      case CarFuel.diesel:
        return 'Diesel';
      case CarFuel.hybrid:
        return 'Hybrid';
      case CarFuel.electric:
        return 'Electric';
    }
  }
}

/// Car body type enum
enum CarBody {
  stationwagon('STATIONWAGON'),
  sedan('SEDAN'),
  suv('SUV'),
  hatchback('HATCHBACK'),
  coupe('COUPE'),
  convertible('CONVERTIBLE'),
  van('VAN');

  final String value;
  const CarBody(this.value);

  static CarBody fromString(String value) {
    return CarBody.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => CarBody.sedan,
    );
  }

  String get displayName {
    switch (this) {
      case CarBody.stationwagon:
        return 'Station Wagon';
      case CarBody.sedan:
        return 'Sedan';
      case CarBody.suv:
        return 'SUV';
      case CarBody.hatchback:
        return 'Hatchback';
      case CarBody.coupe:
        return 'Coupe';
      case CarBody.convertible:
        return 'Convertible';
      case CarBody.van:
        return 'Van';
    }
  }
}
