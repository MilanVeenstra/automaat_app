import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/car.dart';

/// Mapper om te converteren tussen Car entiteit en CarsCache tabel
class CarCacheMapper {
  /// Converteer Car entiteit naar CarsCacheCompanion voor database invoegen
  static CarsCacheCompanion toCompanion(Car car) {
    return CarsCacheCompanion(
      id: Value(car.id),
      brand: Value(car.brand),
      model: Value(car.model),
      picture: Value(car.picture),
      fuel: Value(car.fuel.value),
      licensePlate: Value(car.licensePlate),
      engineSize: Value(car.engineSize),
      modelYear: Value(car.modelYear),
      price: Value(car.price),
      nrOfSeats: Value(car.nrOfSeats),
      body: Value(car.body.value),
      longitude: Value(car.longitude),
      latitude: Value(car.latitude),
      cachedAt: Value(DateTime.now()),
    );
  }

  /// Converteer CarsCacheData van database naar Car entiteit
  static Car toEntity(CarsCacheData cached) {
    return Car(
      id: cached.id,
      brand: cached.brand,
      model: cached.model,
      picture: cached.picture,
      fuel: CarFuel.fromString(cached.fuel),
      licensePlate: cached.licensePlate,
      engineSize: cached.engineSize,
      modelYear: cached.modelYear,
      price: cached.price,
      nrOfSeats: cached.nrOfSeats,
      body: CarBody.fromString(cached.body),
      longitude: cached.longitude,
      latitude: cached.latitude,
    );
  }

  /// Converteer lijst van Cars naar lijst van companions
  static List<CarsCacheCompanion> toCompanions(List<Car> cars) {
    return cars.map((car) => toCompanion(car)).toList();
  }

  /// Converteer lijst van gecachte data naar lijst van entiteiten
  static List<Car> toEntities(List<CarsCacheData> cachedCars) {
    return cachedCars.map((cached) => toEntity(cached)).toList();
  }
}
