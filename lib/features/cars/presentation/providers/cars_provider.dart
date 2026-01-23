import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/favorites_storage.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/cars_remote_datasource.dart';
import '../../data/repositories/cars_repository_impl.dart';
import '../../domain/entities/car.dart';
import '../../domain/repositories/cars_repository.dart';

// Core providers
final favoritesStorageProvider =
    Provider<FavoritesStorage>((ref) => FavoritesStorage());
final carsRemoteDatasourceProvider = Provider<CarsRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CarsRemoteDatasource(dioClient.dio);
});

final carsRepositoryProvider = Provider<CarsRepository>((ref) {
  return CarsRepositoryImpl(
    remoteDatasource: ref.watch(carsRemoteDatasourceProvider),
  );
});

/// Cars list state enum
enum CarsStatus { initial, loading, loaded, error }

/// Cars list state class
class CarsState {
  final CarsStatus status;
  final List<Car> cars;
  final List<Car> filteredCars;
  final String? error;
  final String searchQuery;
  final Set<CarFuel>? fuelFilters;
  final Set<CarBody>? bodyFilters;
  final Set<int> favoriteIds;

  const CarsState({
    this.status = CarsStatus.initial,
    this.cars = const [],
    this.filteredCars = const [],
    this.error,
    this.searchQuery = '',
    this.fuelFilters,
    this.bodyFilters,
    this.favoriteIds = const {},
  });

  CarsState copyWith({
    CarsStatus? status,
    List<Car>? cars,
    List<Car>? filteredCars,
    String? error,
    String? searchQuery,
    Set<CarFuel>? fuelFilters,
    Set<CarBody>? bodyFilters,
    Set<int>? favoriteIds,
  }) {
    return CarsState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      filteredCars: filteredCars ?? this.filteredCars,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      fuelFilters: fuelFilters ?? this.fuelFilters,
      bodyFilters: bodyFilters ?? this.bodyFilters,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}


/// StateNotifier for managing cars list state
class CarsNotifier extends StateNotifier<CarsState> {
  final CarsRepository _repository;
  final FavoritesStorage _favoritesStorage;

  CarsNotifier(this._repository, this._favoritesStorage)
      : super(const CarsState());

  /// Load all cars from the backend
  Future<void> loadCars() async {
    state = state.copyWith(status: CarsStatus.loading);
    try {
      final cars = await _repository.getAllCars();
      final favorites = await _favoritesStorage.getFavorites();
      state = CarsState(
        status: CarsStatus.loaded,
        cars: cars,
        filteredCars: cars,
        favoriteIds: favorites,
      );
    } catch (e) {
      state = CarsState(
        status: CarsStatus.error,
        error: 'Failed to load cars: ${e.toString()}',
      );
    }
  }

  /// Toggle favorite status for a car
  Future<void> toggleFavorite(int carId) async {
    final isFavorite = await _favoritesStorage.toggleFavorite(carId);
    final newFavorites = await _favoritesStorage.getFavorites();
    state = state.copyWith(favoriteIds: newFavorites);
  }

  /// Search cars by query
  void searchCars(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Filter by fuel type
  void toggleFuelFilter(CarFuel fuel) {
    final currentFilters = state.fuelFilters?.toSet() ?? {};
    if (currentFilters.contains(fuel)) {
      currentFilters.remove(fuel);
    } else {
      currentFilters.add(fuel);
    }
    state = state.copyWith(
      fuelFilters: currentFilters.isEmpty ? null : currentFilters,
    );
    _applyFilters();
  }

  /// Filter by body type
  void toggleBodyFilter(CarBody body) {
    final currentFilters = state.bodyFilters?.toSet() ?? {};
    if (currentFilters.contains(body)) {
      currentFilters.remove(body);
    } else {
      currentFilters.add(body);
    }
    state = state.copyWith(
      bodyFilters: currentFilters.isEmpty ? null : currentFilters,
    );
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      fuelFilters: null,
      bodyFilters: null,
      filteredCars: state.cars,
    );
  }

  /// Apply current filters to the cars list
  void _applyFilters() {
    var filtered = state.cars;

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((car) {
        return car.brand.toLowerCase().contains(query) ||
            car.model.toLowerCase().contains(query);
      }).toList();
    }

    // Apply fuel filter
    if (state.fuelFilters != null && state.fuelFilters!.isNotEmpty) {
      filtered = filtered.where((car) {
        return state.fuelFilters!.contains(car.fuel);
      }).toList();
    }

    // Apply body filter
    if (state.bodyFilters != null && state.bodyFilters!.isNotEmpty) {
      filtered = filtered.where((car) {
        return state.bodyFilters!.contains(car.body);
      }).toList();
    }

    state = state.copyWith(filteredCars: filtered);
  }
}

/// Main cars state provider
final carsNotifierProvider =
    StateNotifierProvider<CarsNotifier, CarsState>((ref) {
  return CarsNotifier(
    ref.watch(carsRepositoryProvider),
    ref.watch(favoritesStorageProvider),
  );
});
