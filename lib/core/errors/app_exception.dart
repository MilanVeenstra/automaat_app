/// Base exception class for application errors
sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Exception for network-related errors
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(super.message, {this.statusCode});
}

/// Exception for authentication errors
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Exception for validation errors with field-specific messages
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException(super.message, {this.fieldErrors = const {}});
}
