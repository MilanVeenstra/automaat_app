import '../../../cars/domain/entities/car.dart';
import '../../../auth/domain/entities/user.dart';

/// Rental entity representing a car rental
class Rental {
  final int id;
  final String code;
  final double? longitude;
  final double? latitude;
  final DateTime fromDate;
  final DateTime toDate;
  final RentalState state;
  final User customer;
  final Car car;

  const Rental({
    required this.id,
    required this.code,
    this.longitude,
    this.latitude,
    required this.fromDate,
    required this.toDate,
    required this.state,
    required this.customer,
    required this.car,
  });

  /// Check if rental is currently active
  bool get isActive => state == RentalState.active;

  /// Check if rental is in the past
  bool get isPast => DateTime.now().isAfter(toDate);

  /// Check if rental is upcoming
  bool get isUpcoming => DateTime.now().isBefore(fromDate);

  /// Check if rental is ongoing right now
  bool get isOngoing =>
      DateTime.now().isAfter(fromDate) && DateTime.now().isBefore(toDate);

  Rental copyWith({
    int? id,
    String? code,
    double? longitude,
    double? latitude,
    DateTime? fromDate,
    DateTime? toDate,
    RentalState? state,
    User? customer,
    Car? car,
  }) {
    return Rental(
      id: id ?? this.id,
      code: code ?? this.code,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      state: state ?? this.state,
      customer: customer ?? this.customer,
      car: car ?? this.car,
    );
  }
}

/// Rental state enum
enum RentalState {
  active('ACTIVE'),
  reserved('RESERVED'),
  pickup('PICKUP'),
  returned('RETURNED');

  final String value;
  const RentalState(this.value);

  static RentalState fromString(String value) {
    return RentalState.values.firstWhere(
      (state) => state.value == value.toUpperCase(),
      orElse: () => throw ArgumentError('Unknown rental state: $value'),
    );
  }

  String get displayName {
    switch (this) {
      case RentalState.active:
        return 'Active';
      case RentalState.reserved:
        return 'Reserved';
      case RentalState.pickup:
        return 'Pickup';
      case RentalState.returned:
        return 'Returned';
    }
  }
}
