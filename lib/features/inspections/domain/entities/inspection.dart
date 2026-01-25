import '../../../rentals/domain/entities/rental.dart';

/// Domain entity for Inspection (Damage Report)
class Inspection {
  final int id;
  final String code;
  final int odometer;
  final String result;
  final String? description;
  final String? photo; // Base64 encoded image
  final DateTime? completed;
  final Rental? rental;

  const Inspection({
    required this.id,
    required this.code,
    required this.odometer,
    required this.result,
    this.description,
    this.photo,
    this.completed,
    this.rental,
  });
}
