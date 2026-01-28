/// Basis exception class voor applicatie fouten
sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Exception voor netwerk-gerelateerde fouten
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(super.message, {this.statusCode});
}

/// Exception voor authenticatie fouten
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Exception voor validatie fouten met veld-specifieke berichten
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException(super.message, {this.fieldErrors = const {}});
}
