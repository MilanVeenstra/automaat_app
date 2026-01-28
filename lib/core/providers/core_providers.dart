import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart'
    show dioClientProvider;
import '../../features/inspections/data/datasources/inspections_remote_datasource.dart';
import '../../features/inspections/data/models/create_inspection_request_dto.dart';
import '../../features/rentals/data/datasources/rentals_remote_datasource.dart';
import '../../features/rentals/data/models/update_rental_request_dto.dart';
import '../database/app_database.dart';
import '../network/connectivity_service.dart';
import '../sync/sync_models.dart';
import '../sync/sync_service.dart';

/// Provider voor de app database
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

/// Provider voor connectiviteit service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider voor datasources gebruikt in sync
final _rentalsDataSourceForSyncProvider =
    Provider<RentalsRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RentalsRemoteDatasource(dio: dioClient.dio);
});

final _inspectionsDataSourceForSyncProvider =
    Provider<InspectionsRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return InspectionsRemoteDatasource(dio: dioClient.dio);
});

/// Actie executor voor sync service
SyncActionExecutor _createActionExecutor(Ref ref) {
  return (SyncActionType type, SyncActionPayload payload) async {
    switch (type) {
      case SyncActionType.toggleFavorite:
        // Favorieten zijn alleen lokaal, geen synchronisatie nodig
        break;

      case SyncActionType.endRental:
        final endRentalPayload = payload as EndRentalPayload;
        final datasource = ref.read(_rentalsDataSourceForSyncProvider);

        // Update verhuur
        final updateRequest = UpdateRentalRequestDto(
          id: endRentalPayload.rentalId,
          state: 'RETURNED',
          longitude: endRentalPayload.longitude,
          latitude: endRentalPayload.latitude,
        );
        await datasource.updateRental(
            endRentalPayload.rentalId, updateRequest);

        // Update auto locatie
        await datasource.updateCarLocation(
          endRentalPayload.carId,
          endRentalPayload.longitude,
          endRentalPayload.latitude,
        );
        break;

      case SyncActionType.createDamageReport:
        final reportPayload = payload as CreateDamageReportPayload;
        final datasource = ref.read(_inspectionsDataSourceForSyncProvider);

        final request = CreateInspectionRequestDto(
          rentalId: reportPayload.rentalId,
          odometer: reportPayload.odometer,
          result: reportPayload.result,
          description: reportPayload.description,
          photo: reportPayload.photoBase64,
        );
        await datasource.createInspection(request);
        break;
    }
  };
}

/// Provider voor sync service
final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(
    database: ref.watch(appDatabaseProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    actionExecutor: _createActionExecutor(ref),
  );

  // Start luisteren naar connectiviteit wijzigingen
  service.startListening();

  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider om connectiviteit status te bekijken
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

/// Provider om sync wachtrij aantal te bekijken
final syncQueueCountProvider = StreamProvider<int>((ref) async* {
  final database = ref.watch(appDatabaseProvider);

  // Stuur initiele telling 
  yield await database.getSyncQueueCount();

  // Update elke 5 seconden (of handmatig via refresh)
  await for (final _ in Stream.periodic(const Duration(seconds: 5))) {
    yield await database.getSyncQueueCount();
  }
});
