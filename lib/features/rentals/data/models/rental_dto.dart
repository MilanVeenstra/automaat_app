import '../../../auth/data/models/user_dto.dart';
import '../../../cars/data/models/car_dto.dart';
import '../../domain/entities/rental.dart';

/// DTO for Rental API responses
class RentalDto {
  final int id;
  final String code;
  final double? longitude;
  final double? latitude;
  final String fromDate;
  final String toDate;
  final String state;
  final UserDto customer;
  final CarDto car;

  const RentalDto({
    required this.id,
    required this.code,
    this.longitude,
    this.latitude,
    required this.fromDate,
    required this.toDate,
    required this.state,
    required this.customer,
    required this.car,
  });

  factory RentalDto.fromJson(Map<String, dynamic> json) {
    return RentalDto(
      id: json['id'] as int,
      code: json['code'] as String,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      fromDate: json['fromDate'] as String,
      toDate: json['toDate'] as String,
      state: json['state'] as String,
      customer: UserDto.fromJson(json['customer'] as Map<String, dynamic>),
      car: CarDto.fromJson(json['car'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'longitude': longitude,
      'latitude': latitude,
      'fromDate': fromDate,
      'toDate': toDate,
      'state': state,
      'customer': customer.toJson(),
      'car': car.toJson(),
    };
  }

  Rental toEntity() {
    return Rental(
      id: id,
      code: code,
      longitude: longitude,
      latitude: latitude,
      fromDate: DateTime.parse(fromDate),
      toDate: DateTime.parse(toDate),
      state: RentalState.fromString(state),
      customer: customer.toEntity(),
      car: car.toEntity(),
    );
  }
}
