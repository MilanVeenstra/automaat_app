import '../entities/inspection.dart';

/// Repository interface voor Inspecties
abstract class InspectionsRepository {
  /// Haal alle inspecties op
  Future<List<Inspection>> getInspections();

  /// Haal inspectie op via ID
  Future<Inspection> getInspectionById(int id);

  /// Maak een nieuwe inspectie aan (schade rapport)
  Future<Inspection> createInspection({
    required int rentalId,
    required int odometer,
    required String result,
    String? description,
    String? photoBase64,
  });
}
