/// DTO for updating a rental
class UpdateRentalRequestDto {
  final String? state;
  final double? longitude;
  final double? latitude;

  const UpdateRentalRequestDto({
    this.state,
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (state != null) json['state'] = state;
    if (longitude != null) json['longitude'] = longitude;
    if (latitude != null) json['latitude'] = latitude;
    return json;
  }
}
