import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure opslag wrapper voor JWT token persistentie
class TokenStorage {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'jwt_token';

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Sla JWT token op in secure opslag
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Haal JWT token op uit secure opslag
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// Verwijder JWT token uit secure opslag
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Controleer of een geldige token bestaat
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
