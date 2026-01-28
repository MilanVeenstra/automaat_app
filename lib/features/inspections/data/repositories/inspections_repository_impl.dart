import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/sync/sync_models.dart';
import '../../domain/entities/inspection.dart';
import '../../domain/repositories/inspections_repository.dart';
import '../datasources/inspections_remote_datasource.dart';
import '../models/create_inspection_request_dto.dart';

/// Implementatie van InspectionsRepository met offline ondersteuning
class InspectionsRepositoryImpl implements InspectionsRepository {
  final InspectionsRemoteDatasource _remoteDatasource;
  final AppDatabase _database;
  final ConnectivityService _connectivityService;

  InspectionsRepositoryImpl({
    required InspectionsRemoteDatasource remoteDatasource,
    required AppDatabase database,
    required ConnectivityService connectivityService,
  })  : _remoteDatasource = remoteDatasource,
        _database = database,
        _connectivityService = connectivityService;

  @override
  Future<List<Inspection>> getInspections() async {
    final dtos = await _remoteDatasource.getInspections();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Inspection> getInspectionById(int id) async {
    final dto = await _remoteDatasource.getInspectionById(id);
    return dto.toEntity();
  }

  @override
  Future<Inspection> createInspection({
    required int rentalId,
    required int odometer,
    required String result,
    String? description,
    String? photoBase64,
  }) async {
    final isConnected = await _connectivityService.isConnected;

    if (isConnected) {
      // Online - voer normaal uit
      final request = CreateInspectionRequestDto(
        rentalId: rentalId,
        odometer: odometer,
        result: result,
        description: description,
        photo: photoBase64,
      );
      final dto = await _remoteDatasource.createInspection(request);
      return dto.toEntity();
    } else {
      // Offline - plaats actie in wachtrij
      final payload = CreateDamageReportPayload(
        rentalId: rentalId,
        result: result,
        odometer: odometer,
        description: description,
        photoBase64: photoBase64,
      );

      await _database.addToSyncQueue(
        SyncQueueCompanion(
          actionType: Value(SyncActionType.createDamageReport.toJson()),
          payload: Value(SyncPayloadCodec.encode(payload)),
          createdAt: Value(DateTime.now()),
        ),
      );

      // Gooi exception om aan te geven dat actie in wachtrij is geplaatst
      throw Exception(
          'Offline: Damage report queued for sync when connection returns');
    }
  }
}
