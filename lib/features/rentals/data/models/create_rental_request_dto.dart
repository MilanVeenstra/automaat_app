/// DTO for creating a new rental
class CreateRentalRequestDto {
  final int carId;
  final int customerId;
  final String fromDate;
  final String toDate;
  final String state;
  final double? longitude;
  final double? latitude;

  const CreateRentalRequestDto({
    required this.carId,
    required this.customerId,
    required this.fromDate,
    required this.toDate,
    required this.state,
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'car': {'id': carId},
      'customer': {'id': customerId},
      'fromDate': fromDate,
      'toDate': toDate,
      'state': state,
      if (longitude != null) 'longitude': longitude,
      if (latitude != null) 'latitude': latitude,
    };
  }
}
