import '../../domain/entities/user.dart';

/// DTO for user data from API
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

  /// Parse from /api/AM/me response (Customer with nested systemUser)
  factory UserDto.fromJson(Map<String, dynamic> json) {
    // The /api/AM/me endpoint returns a Customer object with nested systemUser
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
    // Fallback for flat user structure (e.g., from register response)
    return UserDto(
      id: json['id'] as int,
      login: json['login'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  /// Convert DTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }

  /// Convert DTO to domain entity
  User toEntity() => User(
        id: id,
        login: login,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
}
