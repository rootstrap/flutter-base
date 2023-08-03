import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  final SessionCubit _sessionCubit;

  AuthService(this._authRepository, this._sessionCubit);

  void logInWithCredentials(String username, String password) async {
    _sessionCubit.isLoading();
    final result = await _authRepository.login(username, password);
    _sessionCubit.onResult(result);
  }

  void onValidate() {
    if (_authRepository.isLoggedIn()) {
      _sessionCubit.isLogin();
    } else {
      _sessionCubit.isLogOut();
    }
  }

  void onLogout() async {
    await _authRepository.logout();
    _sessionCubit.isLogOut();
  }
}
