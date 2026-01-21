import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Dio interceptor that adds JWT token to request headers
class JwtInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  JwtInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
