import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/rentals_remote_datasource.dart';
import '../../data/repositories/rentals_repository_impl.dart';
import '../../domain/entities/rental.dart';
import '../../domain/repositories/rentals_repository.dart';

/// Provider for RentalsRemoteDatasource
final rentalsRemoteDatasourceProvider = Provider<RentalsRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RentalsRemoteDatasource(dio: dioClient.dio);
});

/// Provider for RentalsRepository
final rentalsRepositoryProvider = Provider<RentalsRepository>((ref) {
  return RentalsRepositoryImpl(
    remoteDatasource: ref.watch(rentalsRemoteDatasourceProvider),
  );
});

/// Rentals state enum
enum RentalsStatus { initial, loading, loaded, error }

/// Rentals state class
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

/// Rentals notifier
class RentalsNotifier extends StateNotifier<RentalsState> {
  final RentalsRepository _repository;

  RentalsNotifier(this._repository) : super(const RentalsState());

  /// Load all rentals for the current user
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

  /// Create a new rental
  Future<bool> createRental({
    required int carId,
    required int customerId,
    required DateTime fromDate,
    required DateTime toDate,
    double? longitude,
    double? latitude,
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

      // Add new rental to state
      state = state.copyWith(
        rentals: [...state.rentals, rental],
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// End a rental
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

      // Update rental in state
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

  /// Get active rental for a car
  Future<Rental?> getActiveRentalForCar(int carId) async {
    try {
      return await _repository.getActiveRentalForCar(carId);
    } catch (e) {
      return null;
    }
  }

  /// Get active rentals
  List<Rental> get activeRentals {
    return state.rentals.where((r) => r.isActive).toList();
  }

  /// Get past rentals
  List<Rental> get pastRentals {
    return state.rentals
        .where((r) => r.state == RentalState.returned)
        .toList();
  }
}

/// Provider for RentalsNotifier
final rentalsNotifierProvider =
    StateNotifierProvider<RentalsNotifier, RentalsState>((ref) {
  return RentalsNotifier(ref.watch(rentalsRepositoryProvider));
});
