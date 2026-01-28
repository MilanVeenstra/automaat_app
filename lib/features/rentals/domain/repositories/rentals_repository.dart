import '../entities/rental.dart';

/// Repository interface voor verhuur operaties
abstract class RentalsRepository {
  /// Haal alle verhuren voor de huidige gebruiker op
  Future<List<Rental>> getMyRentals();

  /// Haal verhuur op via ID
  Future<Rental> getRentalById(int id);

  /// Maak een nieuwe verhuur aan
  Future<Rental> createRental({
    required int carId,
    required int customerId,
    required DateTime fromDate,
    required DateTime toDate,
    double? longitude,
    double? latitude,
  });

  /// Start een verhuur (update RESERVED naar ACTIVE status)
  Future<Rental> startRental({
    required int rentalId,
    required double longitude,
    required double latitude,
  });

  /// Beëindig een verhuur (update naar RETURNED status en update auto locatie)
  Future<Rental> endRental({
    required int rentalId,
    required int carId,
    required double longitude,
    required double latitude,
  });

  /// Haal actieve verhuur voor een specifieke auto op
  Future<Rental?> getActiveRentalForCar(int carId);
}
