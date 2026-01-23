import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../cars/data/models/car_dto.dart';
import '../models/create_rental_request_dto.dart';
import '../models/rental_dto.dart';
import '../models/update_rental_request_dto.dart';

/// Remote datasource for rentals API
class RentalsRemoteDatasource {
  final Dio _dio;

  RentalsRemoteDatasource({required Dio dio}) : _dio = dio;

  /// Get all rentals for the current user
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

  /// Get rental by ID
  Future<RentalDto> getRentalById(int id) async {
    try {
      final response = await _dio.get(ApiConfig.rentalById(id));
      return RentalDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load rental: $e');
    }
  }

  /// Create a new rental
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

  /// Update a rental
  Future<RentalDto> updateRental(
    int rentalId,
    UpdateRentalRequestDto request,
  ) async {
    try {
      final response = await _dio.patch(
        ApiConfig.rentalById(rentalId),
        data: request.toJson(),
      );
      return RentalDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update rental: $e');
    }
  }

  /// Update car location
  Future<CarDto> updateCarLocation(
    int carId,
    double longitude,
    double latitude,
  ) async {
    try {
      final response = await _dio.patch(
        ApiConfig.carById(carId),
        data: {
          'longitude': longitude,
          'latitude': latitude,
        },
      );
      return CarDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update car location: $e');
    }
  }

  /// Get active rentals for a specific car
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
