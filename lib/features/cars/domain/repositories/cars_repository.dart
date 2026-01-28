import '../entities/car.dart';

/// Abstracte interface voor auto operaties
abstract class CarsRepository {
  /// Haal alle beschikbare auto's op
  Future<List<Car>> getAllCars();

  /// Haal een enkele auto op via ID
  Future<Car> getCarById(int id);

  /// Zoek auto's op query (merk of model)
  Future<List<Car>> searchCars(String query);
}
