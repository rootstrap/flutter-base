import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthCubit', () {
    late AuthCubit cubit;

    setUp(() {
      cubit = AuthCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('emits AuthStateAuthenticated when isLogin is called', () {
      cubit.isLogin();

      expect(cubit.state, isA<Success<AuthState>>());

      final successState = cubit.state as Success<AuthState>;

      expect(successState.data, isA<AuthStateAuthenticated>());
    });

    test('emits AuthStateUnauthenticated when isLogOut is called', () {
      cubit.isLogOut();

      expect(cubit.state, isA<Success<AuthState>>());

      final successState = cubit.state as Success<AuthState>;

      expect(successState.data, isA<AuthStateUnauthenticated>());
    });

    test('emits AuthStateUnknown when isUnknown is called', () {
      cubit.isUnknown();

      expect(cubit.state, isA<Success<AuthState>>());

      final successState = cubit.state as Success<AuthState>;

      expect(successState.data, isA<AuthStateUnknown>());
    });
  });
}
