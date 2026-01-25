import '../../domain/entities/inspection.dart';
import '../../domain/repositories/inspections_repository.dart';
import '../datasources/inspections_remote_datasource.dart';
import '../models/create_inspection_request_dto.dart';

/// Implementation of InspectionsRepository
class InspectionsRepositoryImpl implements InspectionsRepository {
  final InspectionsRemoteDatasource _remoteDatasource;

  InspectionsRepositoryImpl({
    required InspectionsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

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
    final request = CreateInspectionRequestDto(
      rentalId: rentalId,
      odometer: odometer,
      result: result,
      description: description,
      photo: photoBase64,
    );
    final dto = await _remoteDatasource.createInspection(request);
    return dto.toEntity();
  }
}
