import '../../../../core/network/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';

/// Implementation of [AuthRepository] using remote API
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required TokenStorage tokenStorage,
  })  : _remoteDatasource = remoteDatasource,
        _tokenStorage = tokenStorage;

  @override
  Future<String> login(String username, String password) async {
    final request = LoginRequestDto(username: username, password: password);
    final response = await _remoteDatasource.login(request);
    await _tokenStorage.saveToken(response.idToken);
    return response.idToken;
  }

  @override
  Future<User> register({
    required String login,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final request = RegisterRequestDto(
      login: login,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    final userDto = await _remoteDatasource.register(request);
    return userDto.toEntity();
  }

  @override
  Future<User> getCurrentUser() async {
    final userDto = await _remoteDatasource.getCurrentUser();
    return userDto.toEntity();
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    return _tokenStorage.hasToken();
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _remoteDatasource.requestPasswordReset(email);
  }

  @override
  Future<void> finishPasswordReset(String key, String newPassword) async {
    await _remoteDatasource.finishPasswordReset(key, newPassword);
  }
}
