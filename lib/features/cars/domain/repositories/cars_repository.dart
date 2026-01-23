import '../entities/car.dart';

/// Abstract interface for cars operations
abstract class CarsRepository {
  /// Get all available cars
  Future<List<Car>> getAllCars();

  /// Get a single car by ID
  Future<Car> getCarById(int id);

  /// Search cars by query (brand or model)
  Future<List<Car>> searchCars(String query);
}
