import 'package:common/core/result_type.dart';
import 'package:data/preferences/preferences.dart';
import 'package:data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockPreferences extends Mock implements Preferences {}

void main() {
  late AuthRepositoryImpl repository;
  late MockPreferences mockPreferences;

  setUp(() {
    mockPreferences = MockPreferences();
    repository = AuthRepositoryImpl(mockPreferences);
  });

  group('isLoggedIn', () {
    test('should return true when token exists', () {
      // Arrange
      when(() => mockPreferences.getToken()).thenReturn('some-token');

      // Act
      final result = repository.isLoggedIn();

      // Assert
      expect(result, true);
      verify(() => mockPreferences.getToken()).called(1);
    });

    test('should return false when token is null', () {
      // Arrange
      when(() => mockPreferences.getToken()).thenReturn(null);

      // Act
      final result = repository.isLoggedIn();

      // Assert
      expect(result, false);
      verify(() => mockPreferences.getToken()).called(1);
    });
  });

  group('login', () {
    test('should return success and set token when login is successful',
        () async {
      // Arrange
      const username = 'test_user';
      const password = 'test_password';
      when(() => mockPreferences.setToken(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.login(username, password);

      // Assert
      expect(result, isA<TSuccess>());
      verify(() => mockPreferences.setToken('new-token')).called(1);
    });
  });

  group('logout', () {
    test('should clear token when logging out', () async {
      // Arrange
      when(() => mockPreferences.setToken(null)).thenAnswer((_) async {});

      // Act
      await repository.logout();

      // Assert
      verify(() => mockPreferences.setToken(null)).called(1);
    });
  });
}
