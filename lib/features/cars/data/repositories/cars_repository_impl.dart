import '../../../../core/database/app_database.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/cars_repository.dart';
import '../datasources/cars_remote_datasource.dart';
import '../mappers/car_cache_mapper.dart';

/// Implementatie van [CarsRepository] met offline-first ondersteuning
class CarsRepositoryImpl implements CarsRepository {
  final CarsRemoteDatasource _remoteDatasource;
  final AppDatabase _database;
  final ConnectivityService _connectivityService;

  CarsRepositoryImpl({
    required CarsRemoteDatasource remoteDatasource,
    required AppDatabase database,
    required ConnectivityService connectivityService,
  })  : _remoteDatasource = remoteDatasource,
        _database = database,
        _connectivityService = connectivityService;

  @override
  Future<List<Car>> getAllCars() async {
    final isConnected = await _connectivityService.isConnected;

    if (isConnected) {
      try {
        // Haal op van remote
        final dtos = await _remoteDatasource.getAllCars();
        final cars = dtos.map((dto) => dto.toEntity()).toList();

        // Cache de resultaten
        final companions = CarCacheMapper.toCompanions(cars);
        await _database.cacheAllCars(companions);

        return cars;
      } catch (e) {
        // Als remote ophalen faalt, val terug naar cache
        final cachedCars = await _database.getAllCachedCars();
        if (cachedCars.isNotEmpty) {
          return CarCacheMapper.toEntities(cachedCars);
        }
        rethrow;
      }
    } else {
      // Offline - retourneer gecachte data
      final cachedCars = await _database.getAllCachedCars();
      return CarCacheMapper.toEntities(cachedCars);
    }
  }

  @override
  Future<Car> getCarById(int id) async {
    final isConnected = await _connectivityService.isConnected;

    if (isConnected) {
      try {
        // Haal op van remote
        final dto = await _remoteDatasource.getCarById(id);
        final car = dto.toEntity();

        // Cache het resultaat
        final companion = CarCacheMapper.toCompanion(car);
        await _database.cacheCar(companion);

        return car;
      } catch (e) {
        // Als remote ophalen faalt, val terug naar cache
        final cachedCar = await _database.getCachedCarById(id);
        if (cachedCar != null) {
          return CarCacheMapper.toEntity(cachedCar);
        }
        rethrow;
      }
    } else {
      // Offline - retourneer gecachte data
      final cachedCar = await _database.getCachedCarById(id);
      if (cachedCar != null) {
        return CarCacheMapper.toEntity(cachedCar);
      }
      throw Exception('Car not found in cache');
    }
  }

  @override
  Future<List<Car>> searchCars(String query) async {
    // Haal alle auto's op (van remote of cache) en filter lokaal
    final cars = await getAllCars();
    final lowerQuery = query.toLowerCase();
    return cars.where((car) {
      return car.brand.toLowerCase().contains(lowerQuery) ||
          car.model.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
