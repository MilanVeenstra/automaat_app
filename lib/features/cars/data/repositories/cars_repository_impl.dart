import '../../domain/entities/car.dart';
import '../../domain/repositories/cars_repository.dart';
import '../datasources/cars_remote_datasource.dart';

/// Implementation of [CarsRepository] using remote API
class CarsRepositoryImpl implements CarsRepository {
  final CarsRemoteDatasource _remoteDatasource;

  CarsRepositoryImpl({
    required CarsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<List<Car>> getAllCars() async {
    final dtos = await _remoteDatasource.getAllCars();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Car> getCarById(int id) async {
    final dto = await _remoteDatasource.getCarById(id);
    return dto.toEntity();
  }

  @override
  Future<List<Car>> searchCars(String query) async {
    // Get all cars and filter locally
    final cars = await getAllCars();
    final lowerQuery = query.toLowerCase();
    return cars.where((car) {
      return car.brand.toLowerCase().contains(lowerQuery) ||
          car.model.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
