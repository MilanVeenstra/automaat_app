import '../entities/inspection.dart';

/// Repository interface for Inspections
abstract class InspectionsRepository {
  /// Get all inspections
  Future<List<Inspection>> getInspections();

  /// Get inspection by ID
  Future<Inspection> getInspectionById(int id);

  /// Create a new inspection (damage report)
  Future<Inspection> createInspection({
    required int rentalId,
    required int odometer,
    required String result,
    String? description,
    String? photoBase64,
  });
}
