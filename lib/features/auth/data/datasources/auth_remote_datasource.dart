import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../models/auth_response_dto.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';
import '../models/user_dto.dart';

/// Remote data source voor authenticatie API calls
class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  /// Authenticeer gebruiker en haal JWT token op
  Future<AuthResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConfig.login,
      data: request.toJson(),
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  /// Registreer nieuwe gebruiker via AutoMaat endpoint
  Future<UserDto> register(RegisterRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConfig.register,
      data: request.toJson(),
    );
    return UserDto.fromJson(response.data!);
  }

  /// Haal huidige geauthenticeerde gebruiker op
  Future<UserDto> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiConfig.me);
    return UserDto.fromJson(response.data!);
  }

  /// Vraag wachtwoord reset email aan
  Future<void> requestPasswordReset(String email) async {
    await _dio.post(
      ApiConfig.resetPasswordInit,
      data: email,
      options: Options(
        contentType: 'text/plain',
      ),
    );
  }

  /// Voltooi wachtwoord reset met sleutel en nieuw wachtwoord
  Future<void> finishPasswordReset(String key, String newPassword) async {
    await _dio.post(
      ApiConfig.resetPasswordFinish,
      data: {
        'key': key,
        'newPassword': newPassword,
      },
    );
  }
}
