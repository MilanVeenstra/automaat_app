/// Domain entity representing an authenticated user
class User {
  final int id;
  final String login;
  final String email;
  final String? firstName;
  final String? lastName;

  const User({
    required this.id,
    required this.login,
    required this.email,
    this.firstName,
    this.lastName,
  });

  /// User's display name (full name if available, otherwise login)
  String get displayName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return login;
  }
}
