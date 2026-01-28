import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
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
    database: ref.watch(appDatabaseProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

/// Auto lijst state enum
enum CarsStatus { initial, loading, loaded, error }

/// Auto lijst state class
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
    bool clearFuelFilters = false,
    bool clearBodyFilters = false,
  }) {
    return CarsState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      filteredCars: filteredCars ?? this.filteredCars,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      fuelFilters: clearFuelFilters ? null : (fuelFilters ?? this.fuelFilters),
      bodyFilters: clearBodyFilters ? null : (bodyFilters ?? this.bodyFilters),
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}


/// StateNotifier voor het beheren van auto lijst state
class CarsNotifier extends StateNotifier<CarsState> {
  final CarsRepository _repository;
  final FavoritesStorage _favoritesStorage;

  CarsNotifier(this._repository, this._favoritesStorage)
      : super(const CarsState());

  /// Laad alle auto's van de backend
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

  /// Schakel favoriet status voor een auto om
  Future<void> toggleFavorite(int carId) async {
    final isFavorite = await _favoritesStorage.toggleFavorite(carId);
    final newFavorites = await _favoritesStorage.getFavorites();
    state = state.copyWith(favoriteIds: newFavorites);
  }

  /// Zoek auto's op query
  void searchCars(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Filter op brandstof type
  void toggleFuelFilter(CarFuel fuel) {
    final currentFilters = state.fuelFilters?.toSet() ?? {};
    if (currentFilters.contains(fuel)) {
      currentFilters.remove(fuel);
    } else {
      currentFilters.add(fuel);
    }
    state = state.copyWith(
      fuelFilters: currentFilters.isEmpty ? null : currentFilters,
      clearFuelFilters: currentFilters.isEmpty,
    );
    _applyFilters();
  }

  /// Filter op carrosserie type
  void toggleBodyFilter(CarBody body) {
    final currentFilters = state.bodyFilters?.toSet() ?? {};
    if (currentFilters.contains(body)) {
      currentFilters.remove(body);
    } else {
      currentFilters.add(body);
    }
    state = state.copyWith(
      bodyFilters: currentFilters.isEmpty ? null : currentFilters,
      clearBodyFilters: currentFilters.isEmpty,
    );
    _applyFilters();
  }

  /// Wis alle filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      clearFuelFilters: true,
      clearBodyFilters: true,
      filteredCars: state.cars,
    );
  }

  /// Pas huidige filters toe op de auto lijst
  void _applyFilters() {
    var filtered = state.cars;

    // Pas zoekquery toe
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((car) {
        return car.brand.toLowerCase().contains(query) ||
            car.model.toLowerCase().contains(query);
      }).toList();
    }

    // Pas brandstof filter toe
    if (state.fuelFilters != null && state.fuelFilters!.isNotEmpty) {
      filtered = filtered.where((car) {
        return state.fuelFilters!.contains(car.fuel);
      }).toList();
    }

    // Pas carrosserie filter toe
    if (state.bodyFilters != null && state.bodyFilters!.isNotEmpty) {
      filtered = filtered.where((car) {
        return state.bodyFilters!.contains(car.body);
      }).toList();
    }

    state = state.copyWith(filteredCars: filtered);
  }
}

/// Hoofd auto state provider
final carsNotifierProvider =
    StateNotifierProvider<CarsNotifier, CarsState>((ref) {
  return CarsNotifier(
    ref.watch(carsRepositoryProvider),
    ref.watch(favoritesStorageProvider),
  );
});
