import 'package:common/core/result_type.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  final AuthCubit _sessionCubit;

  AuthService(this._authRepository, this._sessionCubit);

  Future<void> logInWithCredentials(String username, String password) async {
    _sessionCubit.isLoading();
    final result = await _authRepository.login(username, password);
    switch (result) {
      case TSuccess<void> _:
        _sessionCubit.isLogin();
      case TError<void> _:
        _sessionCubit.isError(result.error);
    }
  }

  void onValidate() {
    if (_authRepository.isLoggedIn()) {
      _sessionCubit.isLogin();
    } else {
      _sessionCubit.isLogOut();
    }
  }

  Future<void> onLogout() async {
    await _authRepository.logout();
    _sessionCubit.isLogOut();
  }
}
