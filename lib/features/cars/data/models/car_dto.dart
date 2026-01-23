import 'dart:math';

import '../../domain/entities/car.dart';

/// Data Transfer Object for Car
class CarDto {
  final int id;
  final String brand;
  final String model;
  final String? picture;
  final String fuel;
  final String licensePlate;
  final double engineSize;
  final int modelYear;
  final double price;
  final int nrOfSeats;
  final String body;
  final double? longitude;
  final double? latitude;

  CarDto({
    required this.id,
    required this.brand,
    required this.model,
    this.picture,
    required this.fuel,
    required this.licensePlate,
    required this.engineSize,
    required this.modelYear,
    required this.price,
    required this.nrOfSeats,
    required this.body,
    this.longitude,
    this.latitude,
  });

  factory CarDto.fromJson(Map<String, dynamic> json) {
    return CarDto(
      id: json['id'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      picture: json['picture'] as String?,
      fuel: json['fuel'] as String,
      licensePlate: json['licensePlate'] as String,
      engineSize: (json['engineSize'] as num).toDouble(),
      modelYear: json['modelYear'] as int,
      price: (json['price'] as num).toDouble(),
      nrOfSeats: json['nrOfSeats'] as int,
      body: json['body'] as String,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      latitude:
          json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'picture': picture,
      'fuel': fuel,
      'licensePlate': licensePlate,
      'engineSize': engineSize,
      'modelYear': modelYear,
      'price': price,
      'nrOfSeats': nrOfSeats,
      'body': body,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  Car toEntity() {
    return Car(
      id: id,
      brand: brand,
      model: model,
      picture: picture,
      fuel: CarFuel.fromString(fuel),
      licensePlate: licensePlate,
      engineSize: engineSize,
      modelYear: modelYear,
      price: price,
      nrOfSeats: nrOfSeats,
      body: CarBody.fromString(body),
      longitude: longitude,
      latitude: latitude,
    );
  }
}
