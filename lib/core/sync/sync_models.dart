import 'dart:convert';

/// Types acties die in de wachtrij kunnen worden geplaatst voor synchronisatie
enum SyncActionType {
  toggleFavorite,
  endRental,
  createDamageReport;

  String toJson() => name;

  static SyncActionType fromJson(String json) {
    return SyncActionType.values.firstWhere((e) => e.name == json);
  }
}

/// Basis class voor sync actie payloads
abstract class SyncActionPayload {
  Map<String, dynamic> toJson();
}

/// Payload voor favoriet omschakelen
class ToggleFavoritePayload extends SyncActionPayload {
  final int carId;
  final bool isFavorite;

  ToggleFavoritePayload({
    required this.carId,
    required this.isFavorite,
  });

  @override
  Map<String, dynamic> toJson() => {
        'carId': carId,
        'isFavorite': isFavorite,
      };

  factory ToggleFavoritePayload.fromJson(Map<String, dynamic> json) {
    return ToggleFavoritePayload(
      carId: json['carId'] as int,
      isFavorite: json['isFavorite'] as bool,
    );
  }
}

/// Payload voor verhuur beëindigen
class EndRentalPayload extends SyncActionPayload {
  final int rentalId;
  final int carId;
  final double longitude;
  final double latitude;

  EndRentalPayload({
    required this.rentalId,
    required this.carId,
    required this.longitude,
    required this.latitude,
  });

  @override
  Map<String, dynamic> toJson() => {
        'rentalId': rentalId,
        'carId': carId,
        'longitude': longitude,
        'latitude': latitude,
      };

  factory EndRentalPayload.fromJson(Map<String, dynamic> json) {
    return EndRentalPayload(
      rentalId: json['rentalId'] as int,
      carId: json['carId'] as int,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );
  }
}

/// Payload voor schade rapport aanmaken
class CreateDamageReportPayload extends SyncActionPayload {
  final int rentalId;
  final String result;
  final int odometer;
  final String? description;
  final String? photoBase64;

  CreateDamageReportPayload({
    required this.rentalId,
    required this.result,
    required this.odometer,
    this.description,
    this.photoBase64,
  });

  @override
  Map<String, dynamic> toJson() => {
        'rentalId': rentalId,
        'result': result,
        'odometer': odometer,
        if (description != null) 'description': description,
        if (photoBase64 != null) 'photoBase64': photoBase64,
      };

  factory CreateDamageReportPayload.fromJson(Map<String, dynamic> json) {
    return CreateDamageReportPayload(
      rentalId: json['rentalId'] as int,
      result: json['result'] as String,
      odometer: json['odometer'] as int,
      description: json['description'] as String?,
      photoBase64: json['photoBase64'] as String?,
    );
  }
}

/// Helper voor het coderen/decoderen van payloads
class SyncPayloadCodec {
  static String encode(SyncActionPayload payload) {
    return jsonEncode(payload.toJson());
  }

  static SyncActionPayload decode(
      SyncActionType type, String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    switch (type) {
      case SyncActionType.toggleFavorite:
        return ToggleFavoritePayload.fromJson(json);
      case SyncActionType.endRental:
        return EndRentalPayload.fromJson(json);
      case SyncActionType.createDamageReport:
        return CreateDamageReportPayload.fromJson(json);
    }
  }
}
