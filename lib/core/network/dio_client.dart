import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'jwt_interceptor.dart';
import 'token_storage.dart';

/// Configured Dio HTTP client with JWT interceptor
class DioClient {
  late final Dio dio;

  DioClient({required TokenStorage tokenStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      JwtInterceptor(tokenStorage),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }
}
