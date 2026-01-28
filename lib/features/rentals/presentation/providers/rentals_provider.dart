import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/providers/notification_providers.dart';
import '../../../../core/storage/settings_storage.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cars/domain/entities/car.dart';
import '../../data/datasources/rentals_remote_datasource.dart';
import '../../data/repositories/rentals_repository_impl.dart';
import '../../domain/entities/rental.dart';
import '../../domain/repositories/rentals_repository.dart';

/// Provider voor RentalsRemoteDatasource
final rentalsRemoteDatasourceProvider = Provider<RentalsRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RentalsRemoteDatasource(dio: dioClient.dio);
});

/// Provider voor RentalsRepository
final rentalsRepositoryProvider = Provider<RentalsRepository>((ref) {
  return RentalsRepositoryImpl(
    remoteDatasource: ref.watch(rentalsRemoteDatasourceProvider),
    database: ref.watch(appDatabaseProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

/// Verhuur state enum
enum RentalsStatus { initial, loading, loaded, error }

/// Verhuur state class
class RentalsState {
  final RentalsStatus status;
  final List<Rental> rentals;
  final String? error;

  const RentalsState({
    this.status = RentalsStatus.initial,
    this.rentals = const [],
    this.error,
  });

  RentalsState copyWith({
    RentalsStatus? status,
    List<Rental>? rentals,
    String? error,
  }) {
    return RentalsState(
      status: status ?? this.status,
      rentals: rentals ?? this.rentals,
      error: error ?? this.error,
    );
  }
}

/// Verhuur notifier
class RentalsNotifier extends StateNotifier<RentalsState> {
  final RentalsRepository _repository;
  final NotificationService _notificationService;
  final SettingsStorage _settingsStorage;

  RentalsNotifier(
    this._repository,
    this._notificationService,
    this._settingsStorage,
  ) : super(const RentalsState());

  /// Laad alle verhuren voor de huidige gebruiker
  Future<void> loadRentals() async {
    state = state.copyWith(status: RentalsStatus.loading);
    try {
      final rentals = await _repository.getMyRentals();
      state = state.copyWith(
        status: RentalsStatus.loaded,
        rentals: rentals,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: RentalsStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Maak een nieuwe verhuur aan
  Future<bool> createRental({
    required int carId,
    required int customerId,
    required DateTime fromDate,
    required DateTime toDate,
    double? longitude,
    double? latitude,
    Car? car,
  }) async {
    try {
      final rental = await _repository.createRental(
        carId: carId,
        customerId: customerId,
        fromDate: fromDate,
        toDate: toDate,
        longitude: longitude,
        latitude: latitude,
      );

      // Gebruik volledige auto object indien beschikbaar
      final rentalWithFullCar = car != null
          ? rental.copyWith(car: car)
          : rental;

      // Voeg verhuur toe aan state
      state = state.copyWith(
        rentals: [...state.rentals, rentalWithFullCar],
      );

      // Plan notificaties indien ingeschakeld
      try {
        final notificationsEnabled = await _settingsStorage.areNotificationsEnabled();
        if (notificationsEnabled) {
          final carInfo = '${rentalWithFullCar.car.brand} ${rentalWithFullCar.car.model} (${rentalWithFullCar.car.licensePlate})';
          await _notificationService.scheduleRentalStartReminder(
            rentalId: rentalWithFullCar.id,
            startTime: rentalWithFullCar.fromDate,
            carInfo: carInfo,
          );
          await _notificationService.scheduleRentalEndReminder(
            rentalId: rentalWithFullCar.id,
            endTime: rentalWithFullCar.toDate,
            carInfo: carInfo,
          );
        }
      } catch (e) {
        // Notificaties plannen mislukt, maar verhuur succesvol aangemaakt
        // Fout wordt genegeerd omdat verhuur zelf wel gelukt is
      }
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Start een verhuur (RESERVED -> ACTIVE)
  Future<bool> startRental({
    required int rentalId,
    required double longitude,
    required double latitude,
  }) async {
    try {
      final updatedRental = await _repository.startRental(
        rentalId: rentalId,
        longitude: longitude,
        latitude: latitude,
      );

      // Update verhuur in state
      state = state.copyWith(
        rentals: state.rentals
            .map((r) => r.id == rentalId ? updatedRental : r)
            .toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Beëindig een verhuur
  Future<bool> endRental({
    required int rentalId,
    required int carId,
    required double longitude,
    required double latitude,
  }) async {
    try {
      final updatedRental = await _repository.endRental(
        rentalId: rentalId,
        carId: carId,
        longitude: longitude,
        latitude: latitude,
      );

      // Update verhuur in state
      state = state.copyWith(
        rentals: state.rentals
            .map((r) => r.id == rentalId ? updatedRental : r)
            .toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Haal actieve verhuur voor een auto op
  Future<Rental?> getActiveRentalForCar(int carId) async {
    try {
      return await _repository.getActiveRentalForCar(carId);
    } catch (e) {
      return null;
    }
  }

  /// Haal actieve verhuren op (inclusief gereserveerd en actief)
  List<Rental> get activeRentals {
    return state.rentals
        .where((r) => r.isActive || r.isReserved)
        .toList();
  }

  /// Haal eerdere verhuren op
  List<Rental> get pastRentals {
    return state.rentals
        .where((r) => r.state == RentalState.returned)
        .toList();
  }
}

/// Provider voor RentalsNotifier
final rentalsNotifierProvider =
    StateNotifierProvider<RentalsNotifier, RentalsState>((ref) {
  return RentalsNotifier(
    ref.watch(rentalsRepositoryProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(settingsStorageProvider),
  );
});
