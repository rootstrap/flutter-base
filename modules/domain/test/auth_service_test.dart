import 'package:common/core/result_type.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionCubit extends Mock implements AuthCubit {}

void main() {
  late AuthRepository mockAuthRepository;
  late AuthCubit mockSessionCubit;
  late AuthService authService;

  const username = 'testuser';
  const password = 'password123';
  final failure = Exception('Invalid credentials');

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSessionCubit = MockSessionCubit();
    authService = AuthService(mockAuthRepository, mockSessionCubit);
  });

  group('AuthService', () {
    test('logInWithCredentials calls isLogin on success', () async {
      when(() => mockAuthRepository.login(username, password))
          .thenAnswer((_) async => TSuccess(null));
      when(() => mockSessionCubit.isLoading()).thenReturn(null);
      when(() => mockSessionCubit.isLogin()).thenReturn(null);

      await authService.logInWithCredentials(username, password);

      verify(() => mockSessionCubit.isLoading()).called(1);
      verify(() => mockSessionCubit.isLogin()).called(1);
      verifyNever(() => mockSessionCubit.isError(any()));
    });

    test('logInWithCredentials calls isError on failure', () async {
      when(() => mockAuthRepository.login(username, password))
          .thenAnswer((_) async => TError(failure));
      when(() => mockSessionCubit.isLoading()).thenReturn(null);
      when(() => mockSessionCubit.isError(failure)).thenReturn(null);

      await authService.logInWithCredentials(username, password);

      verify(() => mockSessionCubit.isLoading()).called(1);
      verify(() => mockSessionCubit.isError(failure)).called(1);
      verifyNever(() => mockSessionCubit.isLogin());
    });

    test('onValidate calls isLogin when user is logged in', () {
      when(() => mockAuthRepository.isLoggedIn()).thenReturn(true);
      when(() => mockSessionCubit.isLogin()).thenReturn(null);

      authService.onValidate();

      verify(() => mockAuthRepository.isLoggedIn()).called(1);
      verify(() => mockSessionCubit.isLogin()).called(1);
      verifyNever(() => mockSessionCubit.isLogOut());
    });

    test('onValidate calls isLogOut when user is not logged in', () {
      when(() => mockAuthRepository.isLoggedIn()).thenReturn(false);
      when(() => mockSessionCubit.isLogOut()).thenReturn(null);

      authService.onValidate();

      verify(() => mockAuthRepository.isLoggedIn()).called(1);
      verify(() => mockSessionCubit.isLogOut()).called(1);
      verifyNever(() => mockSessionCubit.isLogin());
    });

    test('onLogout calls logout and then isLogOut', () async {
      when(() => mockAuthRepository.logout()).thenAnswer((_) async => {});
      when(() => mockSessionCubit.isLogOut()).thenReturn(null);

      await authService.onLogout();

      verify(() => mockAuthRepository.logout()).called(1);
      verify(() => mockSessionCubit.isLogOut()).called(1);
    });
  });
}
