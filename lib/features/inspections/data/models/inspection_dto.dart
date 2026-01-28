import '../../../rentals/data/models/rental_dto.dart';
import '../../domain/entities/inspection.dart';

/// DTO voor Inspectie API responses
class InspectionDto {
  final int id;
  final String code;
  final int odometer;
  final String result;
  final String? description;
  final String? photo;
  final String? completed;
  final RentalDto? rental;

  const InspectionDto({
    required this.id,
    required this.code,
    required this.odometer,
    required this.result,
    this.description,
    this.photo,
    this.completed,
    this.rental,
  });

  factory InspectionDto.fromJson(Map<String, dynamic> json) {
    return InspectionDto(
      id: json['id'] as int,
      code: json['code'] as String? ?? '',
      odometer: json['odometer'] as int? ?? 0,
      result: json['result'] as String? ?? 'OK',
      description: json['description'] as String?,
      photo: json['photo'] as String?,
      completed: json['completed'] as String?,
      rental: json['rental'] != null
          ? RentalDto.fromJson(json['rental'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'odometer': odometer,
      'result': result,
      if (description != null) 'description': description,
      if (photo != null) 'photo': photo,
      if (completed != null) 'completed': completed,
      if (rental != null) 'rental': rental!.toJson(),
    };
  }

  Inspection toEntity() {
    return Inspection(
      id: id,
      code: code,
      odometer: odometer,
      result: result,
      description: description,
      photo: photo,
      completed: completed != null ? DateTime.parse(completed!) : null,
      rental: rental?.toEntity(),
    );
  }
}
