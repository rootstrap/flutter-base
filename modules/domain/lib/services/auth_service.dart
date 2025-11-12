import 'package:common/core/result_type.dart';
import 'package:domain/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<ResultType<void>> logInWithCredentials(
          String username, String password) =>
      _authRepository.login(username, password);

  bool isLoggedIn() => _authRepository.isLoggedIn();

  Future<void> onLogout() async {
    await _authRepository.logout();
  }
}
