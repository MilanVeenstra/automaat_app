/// DTO for authentication response containing JWT token
class AuthResponseDto {
  final String idToken;

  const AuthResponseDto({required this.idToken});

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(idToken: json['id_token'] as String);
  }
}
