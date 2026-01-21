import 'package:automaat_app/core/network/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TokenStorage tokenStorage;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(storage: mockStorage);
  });

  group('TokenStorage', () {
    const testToken = 'test_jwt_token_12345';
    const tokenKey = 'jwt_token';

    test('saveToken writes token to secure storage', () async {
      when(() => mockStorage.write(key: tokenKey, value: testToken))
          .thenAnswer((_) async {});

      await tokenStorage.saveToken(testToken);

      verify(() => mockStorage.write(key: tokenKey, value: testToken)).called(1);
    });

    test('getToken reads token from secure storage', () async {
      when(() => mockStorage.read(key: tokenKey))
          .thenAnswer((_) async => testToken);

      final result = await tokenStorage.getToken();

      expect(result, testToken);
      verify(() => mockStorage.read(key: tokenKey)).called(1);
    });

    test('getToken returns null when no token exists', () async {
      when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

      final result = await tokenStorage.getToken();

      expect(result, isNull);
    });

    test('deleteToken removes token from secure storage', () async {
      when(() => mockStorage.delete(key: tokenKey)).thenAnswer((_) async {});

      await tokenStorage.deleteToken();

      verify(() => mockStorage.delete(key: tokenKey)).called(1);
    });

    test('hasToken returns true when token exists', () async {
      when(() => mockStorage.read(key: tokenKey))
          .thenAnswer((_) async => testToken);

      final result = await tokenStorage.hasToken();

      expect(result, isTrue);
    });

    test('hasToken returns false when token is null', () async {
      when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

      final result = await tokenStorage.hasToken();

      expect(result, isFalse);
    });

    test('hasToken returns false when token is empty', () async {
      when(() => mockStorage.read(key: tokenKey)).thenAnswer((_) async => '');

      final result = await tokenStorage.hasToken();

      expect(result, isFalse);
    });
  });
}
