/// Domein entiteit die een geauthenticeerde gebruiker representeert
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

  /// Gebruiker's weergave naam (volledige naam indien beschikbaar, anders login)
  String get displayName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return login;
  }
}
