import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../models/car_dto.dart';

/// Remote data source for cars API calls
class CarsRemoteDatasource {
  final Dio _dio;

  CarsRemoteDatasource(this._dio);

  /// Fetch all cars from the backend
  Future<List<CarDto>> getAllCars() async {
    final response = await _dio.get<List<dynamic>>(ApiConfig.cars);
    final List<dynamic> carsJson = response.data!;
    return carsJson
        .map((json) => CarDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single car by ID
  Future<CarDto> getCarById(int id) async {
    final response =
        await _dio.get<Map<String, dynamic>>(ApiConfig.carById(id));
    return CarDto.fromJson(response.data!);
  }
}
