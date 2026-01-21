import '../entities/user.dart';

/// Abstract interface for authentication operations
abstract class AuthRepository {
  /// Login with username and password, returns JWT token
  Future<String> login(String username, String password);

  /// Register a new user
  Future<User> register({
    required String login,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  /// Get the currently authenticated user
  Future<User> getCurrentUser();

  /// Logout the current user (clears stored token)
  Future<void> logout();

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated();

  /// Request a password reset email for the given email address
  Future<void> requestPasswordReset(String email);

  /// Complete password reset with the reset key and new password
  Future<void> finishPasswordReset(String key, String newPassword);
}
