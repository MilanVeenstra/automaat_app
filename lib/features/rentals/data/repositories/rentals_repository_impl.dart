import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/sync/sync_models.dart';
import '../../domain/entities/rental.dart';
import '../../domain/repositories/rentals_repository.dart';
import '../datasources/rentals_remote_datasource.dart';
import '../models/create_rental_request_dto.dart';
import '../models/update_rental_request_dto.dart';

/// Implementatie van RentalsRepository met offline ondersteuning
class RentalsRepositoryImpl implements RentalsRepository {
  final RentalsRemoteDatasource _remoteDatasource;
  final AppDatabase _database;
  final ConnectivityService _connectivityService;

  RentalsRepositoryImpl({
    required RentalsRemoteDatasource remoteDatasource,
    required AppDatabase database,
    required ConnectivityService connectivityService,
  })  : _remoteDatasource = remoteDatasource,
        _database = database,
        _connectivityService = connectivityService;

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
      state: 'RESERVED', // Start as RESERVED, not ACTIVE
      longitude: longitude,
      latitude: latitude,
    );
    final dto = await _remoteDatasource.createRental(request);
    return dto.toEntity();
  }

  @override
  Future<Rental> startRental({
    required int rentalId,
    required double longitude,
    required double latitude,
  }) async {
    final updateRequest = UpdateRentalRequestDto(
      id: rentalId,
      state: 'ACTIVE',
      longitude: longitude,
      latitude: latitude,
    );
    final rentalDto =
        await _remoteDatasource.updateRental(rentalId, updateRequest);
    return rentalDto.toEntity();
  }

  @override
  Future<Rental> endRental({
    required int rentalId,
    required double longitude,
    required double latitude,
    required int carId,
  }) async {
    final isConnected = await _connectivityService.isConnected;

    if (isConnected) {
      // Online - voer direct uit
      final updateRequest = UpdateRentalRequestDto(
        id: rentalId,
        state: 'RETURNED',
        longitude: longitude,
        latitude: latitude,
      );
      final rentalDto =
          await _remoteDatasource.updateRental(rentalId, updateRequest);

      // Update auto locatie
      await _remoteDatasource.updateCarLocation(carId, longitude, latitude);

      return rentalDto.toEntity();
    } else {
      // Offline - voeg toe aan sync wachtrij
      final payload = EndRentalPayload(
        rentalId: rentalId,
        carId: carId,
        longitude: longitude,
        latitude: latitude,
      );

      await _database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.endRental.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Actie in wachtrij geplaatst
      throw Exception(
          'Offline: Rental ending queued for sync when connection returns');
    }
  }

  @override
  Future<Rental?> getActiveRentalForCar(int carId) async {
    final dtos = await _remoteDatasource.getActiveRentalsForCar(carId);
    if (dtos.isEmpty) return null;
    return dtos.first.toEntity();
  }
}
