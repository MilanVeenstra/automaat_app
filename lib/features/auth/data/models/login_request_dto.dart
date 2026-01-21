/// DTO for login request body
class LoginRequestDto {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginRequestDto({
    required this.username,
    required this.password,
    this.rememberMe = true,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'rememberMe': rememberMe,
      };
}
