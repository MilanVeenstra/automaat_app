import '../../../auth/data/models/user_dto.dart';
import '../../../cars/data/models/car_dto.dart';
import '../../domain/entities/rental.dart';

/// DTO voor Verhuur API responses
class RentalDto {
  final int id;
  final String code;
  final double? longitude;
  final double? latitude;
  final String fromDate;
  final String toDate;
  final String state;
  final UserDto? customer;
  final CarDto? car;

  const RentalDto({
    required this.id,
    required this.code,
    this.longitude,
    this.latitude,
    required this.fromDate,
    required this.toDate,
    required this.state,
    this.customer,
    this.car,
  });

  factory RentalDto.fromJson(Map<String, dynamic> json) {
    return RentalDto(
      id: json['id'] as int,
      code: json['code'] as String? ?? '',
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      fromDate: json['fromDate'] as String? ?? '2024-01-01',
      toDate: json['toDate'] as String? ?? '2024-01-01',
      state: json['state'] as String? ?? 'ACTIVE',
      customer: json['customer'] != null
          ? UserDto.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      car: json['car'] != null
          ? CarDto.fromJson(json['car'] as Map<String, dynamic>)
          : null,
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
      if (customer != null) 'customer': customer!.toJson(),
      if (car != null) 'car': car!.toJson(),
    };
  }

  Rental toEntity() {
    // Gebruik dummy waarden indien null
    final dummyCustomer = customer ??
        const UserDto(
          id: 0,
          login: 'unknown',
          email: 'unknown@automaat.com',
        );
    final dummyCar = car ??
        CarDto(
          id: 0,
          brand: 'Unknown',
          model: 'Unknown',
          fuel: 'GASOLINE',
          licensePlate: 'UNKNOWN',
          engineSize: 0,
          modelYear: 2024,
          price: 0,
          nrOfSeats: 4,
          body: 'SEDAN',
        );

    return Rental(
      id: id,
      code: code,
      longitude: longitude,
      latitude: latitude,
      fromDate: DateTime.parse(fromDate),
      toDate: DateTime.parse(toDate),
      state: RentalState.fromString(state),
      customer: dummyCustomer.toEntity(),
      car: dummyCar.toEntity(),
    );
  }
}
