import '../../domain/entities/user.dart';

/// DTO voor gebruiker data van API
class UserDto {
  final int id;
  final String login;
  final String email;
  final String? firstName;
  final String? lastName;

  const UserDto({
    required this.id,
    required this.login,
    required this.email,
    this.firstName,
    this.lastName,
  });

  /// Parse van /api/AM/me response (Customer met geneste systemUser)
  factory UserDto.fromJson(Map<String, dynamic> json) {
    // Het /api/AM/me endpoint retourneert een Customer object met geneste systemUser
    if (json.containsKey('systemUser')) {
      final systemUser = json['systemUser'] as Map<String, dynamic>;
      return UserDto(
        id: systemUser['id'] as int,
        login: systemUser['login'] as String,
        email: systemUser['email'] as String,
        firstName: systemUser['firstName'] as String?,
        lastName: systemUser['lastName'] as String?,
      );
    }
    // Fallback voor platte gebruiker structuur (bijv. van register response of minimale verhuur response)
    return UserDto(
      id: json['id'] as int,
      login: json['login'] as String? ?? 'user${json['id']}',
      email: json['email'] as String? ?? 'user${json['id']}@automaat.com',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  /// Converteer DTO naar JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }

  /// Converteer DTO naar domein entiteit
  User toEntity() => User(
        id: id,
        login: login,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
}
