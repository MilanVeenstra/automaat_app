import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../cars/data/models/car_dto.dart';
import '../models/create_rental_request_dto.dart';
import '../models/rental_dto.dart';
import '../models/update_rental_request_dto.dart';

/// Remote datasource voor verhuur API
class RentalsRemoteDatasource {
  final Dio _dio;

  RentalsRemoteDatasource({required Dio dio}) : _dio = dio;

  /// Haal alle verhuren voor de huidige gebruiker op
  Future<List<RentalDto>> getMyRentals() async {
    try {
      final response = await _dio.get(ApiConfig.rentals);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => RentalDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load rentals: $e');
    }
  }

  /// Haal verhuur op via ID
  Future<RentalDto> getRentalById(int id) async {
    try {
      final response = await _dio.get(ApiConfig.rentalById(id));
      return RentalDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load rental: $e');
    }
  }

  /// Maak een nieuwe verhuur aan
  Future<RentalDto> createRental(CreateRentalRequestDto request) async {
    try {
      final response = await _dio.post(
        ApiConfig.rentals,
        data: request.toJson(),
      );
      return RentalDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create rental: $e');
    }
  }

  /// Update een verhuur
  Future<RentalDto> updateRental(
    int rentalId,
    UpdateRentalRequestDto request,
  ) async {
    try {
      // Zorg dat DTO correct ID heeft
      final requestWithId = UpdateRentalRequestDto(
        id: rentalId,
        state: request.state,
        longitude: request.longitude,
        latitude: request.latitude,
      );
      final response = await _dio.patch(
        ApiConfig.rentalById(rentalId),
        data: requestWithId.toJson(),
      );
      return RentalDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update rental: $e');
    }
  }

  /// Update auto locatie
  Future<CarDto> updateCarLocation(
    int carId,
    double longitude,
    double latitude,
  ) async {
    try {
      final response = await _dio.patch(
        ApiConfig.carById(carId),
        data: {
          'id': carId,
          'longitude': longitude,
          'latitude': latitude,
        },
      );
      return CarDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update car location: $e');
    }
  }

  /// Haal actieve verhuren voor een specifieke auto op
  Future<List<RentalDto>> getActiveRentalsForCar(int carId) async {
    try {
      final response = await _dio.get(
        ApiConfig.rentals,
        queryParameters: {
          'carId.equals': carId,
          'state.equals': 'ACTIVE',
        },
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => RentalDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active rentals: $e');
    }
  }
}
