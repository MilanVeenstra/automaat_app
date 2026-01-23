import '../entities/rental.dart';

/// Repository interface for rentals operations
abstract class RentalsRepository {
  /// Get all rentals for the current user
  Future<List<Rental>> getMyRentals();

  /// Get rental by ID
  Future<Rental> getRentalById(int id);

  /// Create a new rental
  Future<Rental> createRental({
    required int carId,
    required int customerId,
    required DateTime fromDate,
    required DateTime toDate,
    double? longitude,
    double? latitude,
  });

  /// End a rental (update to RETURNED state and update car location)
  Future<Rental> endRental({
    required int rentalId,
    required int carId,
    required double longitude,
    required double latitude,
  });

  /// Get active rental for a specific car
  Future<Rental?> getActiveRentalForCar(int carId);
}
