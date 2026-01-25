import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/inspections_remote_datasource.dart';
import '../../data/repositories/inspections_repository_impl.dart';
import '../../domain/entities/inspection.dart';
import '../../domain/repositories/inspections_repository.dart';

// Datasource provider
final inspectionsRemoteDatasourceProvider =
    Provider<InspectionsRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return InspectionsRemoteDatasource(dio: dioClient.dio);
});

// Repository provider
final inspectionsRepositoryProvider = Provider<InspectionsRepository>((ref) {
  return InspectionsRepositoryImpl(
    remoteDatasource: ref.watch(inspectionsRemoteDatasourceProvider),
  );
});

// State for inspections
class InspectionsState {
  final List<Inspection> inspections;
  final InspectionsStatus status;
  final String? error;

  const InspectionsState({
    this.inspections = const [],
    this.status = InspectionsStatus.initial,
    this.error,
  });

  InspectionsState copyWith({
    List<Inspection>? inspections,
    InspectionsStatus? status,
    String? error,
  }) {
    return InspectionsState(
      inspections: inspections ?? this.inspections,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

enum InspectionsStatus { initial, loading, loaded, error }

// Inspections notifier
class InspectionsNotifier extends StateNotifier<InspectionsState> {
  final InspectionsRepository _repository;

  InspectionsNotifier(this._repository) : super(const InspectionsState());

  /// Load all inspections
  Future<void> loadInspections() async {
    state = state.copyWith(status: InspectionsStatus.loading);
    try {
      final inspections = await _repository.getInspections();
      state = state.copyWith(
        status: InspectionsStatus.loaded,
        inspections: inspections,
      );
    } catch (e) {
      state = state.copyWith(
        status: InspectionsStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Create a new inspection (damage report)
  Future<bool> createInspection({
    required int rentalId,
    required int odometer,
    required String result,
    String? description,
    String? photoBase64,
  }) async {
    try {
      print('Provider: Creating inspection...');
      final inspection = await _repository.createInspection(
        rentalId: rentalId,
        odometer: odometer,
        result: result,
        description: description,
        photoBase64: photoBase64,
      );

      print('Provider: Inspection created successfully: ${inspection.id}');

      // Add to local state
      state = state.copyWith(
        inspections: [...state.inspections, inspection],
      );

      print('Provider: Returning true');
      return true;
    } catch (e, stackTrace) {
      print('Provider: Error creating inspection: $e');
      print('Provider: Stack trace: $stackTrace');
      state = state.copyWith(
        status: InspectionsStatus.error,
        error: e.toString(),
      );
      return false;
    }
  }
}

// Provider
final inspectionsNotifierProvider =
    StateNotifierProvider<InspectionsNotifier, InspectionsState>((ref) {
  final repository = ref.watch(inspectionsRepositoryProvider);
  return InspectionsNotifier(repository);
});
