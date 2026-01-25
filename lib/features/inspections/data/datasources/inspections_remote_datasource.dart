import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../models/create_inspection_request_dto.dart';
import '../models/inspection_dto.dart';

/// Remote datasource for Inspections API
class InspectionsRemoteDatasource {
  final Dio _dio;

  InspectionsRemoteDatasource({required Dio dio}) : _dio = dio;

  /// Get all inspections
  Future<List<InspectionDto>> getInspections() async {
    final response = await _dio.get(ApiConfig.inspections);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => InspectionDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get inspection by ID
  Future<InspectionDto> getInspectionById(int id) async {
    final response = await _dio.get(ApiConfig.inspectionById(id));
    return InspectionDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Create a new inspection
  Future<InspectionDto> createInspection(
      CreateInspectionRequestDto request) async {
    final response = await _dio.post(
      ApiConfig.inspections,
      data: request.toJson(),
    );
    return InspectionDto.fromJson(response.data as Map<String, dynamic>);
  }
}
