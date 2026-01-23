import '../../domain/entities/rental.dart';
import '../../domain/repositories/rentals_repository.dart';
import '../datasources/rentals_remote_datasource.dart';
import '../models/create_rental_request_dto.dart';
import '../models/update_rental_request_dto.dart';

/// Implementation of RentalsRepository
class RentalsRepositoryImpl implements RentalsRepository {
  final RentalsRemoteDatasource _remoteDatasource;

  RentalsRepositoryImpl({required RentalsRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<List<Rental>> getMyRentals() async {
    final dtos = await _remoteDatasource.getMyRentals();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Rental> getRentalById(int id) async {
    final dto = await _remoteDatasource.getRentalById(id);
    return dto.toEntity();
  }

  @override
  Future<Rental> createRental({
    required int carId,
    required DateTime fromDate,
    required DateTime toDate,
    double? longitude,
    double? latitude,
    required int customerId,
  }) async {
    final request = CreateRentalRequestDto(
      carId: carId,
      customerId: customerId,
      fromDate: fromDate.toIso8601String(),
      toDate: toDate.toIso8601String(),
      state: 'ACTIVE',
      longitude: longitude,
      latitude: latitude,
    );
    final dto = await _remoteDatasource.createRental(request);
    return dto.toEntity();
  }

  @override
  Future<Rental> endRental({
    required int rentalId,
    required double longitude,
    required double latitude,
    required int carId,
  }) async {
    // First update the rental to RETURNED state
    final updateRequest = UpdateRentalRequestDto(
      state: 'RETURNED',
      longitude: longitude,
      latitude: latitude,
    );
    final rentalDto =
        await _remoteDatasource.updateRental(rentalId, updateRequest);

    // Then update the car location
    await _remoteDatasource.updateCarLocation(carId, longitude, latitude);

    return rentalDto.toEntity();
  }

  @override
  Future<Rental?> getActiveRentalForCar(int carId) async {
    final dtos = await _remoteDatasource.getActiveRentalsForCar(carId);
    if (dtos.isEmpty) return null;
    return dtos.first.toEntity();
  }
}
