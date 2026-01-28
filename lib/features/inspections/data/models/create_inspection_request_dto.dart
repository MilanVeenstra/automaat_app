/// DTO for creating inspection request
class CreateInspectionRequestDto {
  final int rentalId;
  final int odometer;
  final String result;
  final String? description;
  final String? photo; // Base64 gecodeerde afbeelding

  const CreateInspectionRequestDto({
    required this.rentalId,
    required this.odometer,
    required this.result,
    this.description,
    this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      'rental': {'id': rentalId},
      'odometer': odometer,
      'result': result,
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (photo != null && photo!.isNotEmpty) 'photo': photo,
    };
  }
}
