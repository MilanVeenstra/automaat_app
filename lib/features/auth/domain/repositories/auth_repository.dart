import '../entities/user.dart';

/// Abstracte interface voor authenticatie operaties
abstract class AuthRepository {
  /// Login met gebruikersnaam en wachtwoord, retourneert JWT token
  Future<String> login(String username, String password);

  /// Registreer een nieuwe gebruiker
  Future<User> register({
    required String login,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  /// Haal de huidige geauthenticeerde gebruiker op
  Future<User> getCurrentUser();

  /// Logout de huidige gebruiker (wist opgeslagen token)
  Future<void> logout();

  /// Controleer of gebruiker geauthenticeerd is (heeft geldige token)
  Future<bool> isAuthenticated();

  /// Vraag een wachtwoord reset email aan voor het opgegeven email adres
  Future<void> requestPasswordReset(String email);

  /// Voltooi wachtwoord reset met de reset sleutel en nieuw wachtwoord
  Future<void> finishPasswordReset(String key, String newPassword);
}
