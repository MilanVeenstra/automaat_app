/// DTO for AutoMaat registration request body
class RegisterRequestDto {
  final String login;
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  const RegisterRequestDto({
    required this.login,
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'login': login,
        'email': email,
        'password': password,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
      };
}
