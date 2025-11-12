import 'package:common/core/resource.dart';
import 'package:common/core/result_type.dart';
import 'package:domain/bloc/base_cubit.dart';
import 'package:domain/bloc/auth/auth_state.dart';
import 'package:domain/services/auth_service.dart';

class AuthCubit extends BaseCubit<AuthState> {
  final AuthService _authService;
  AuthCubit(this._authService) : super(RSuccess(data: AuthStateUnknown()));

  Future<void> login(String username, String password) async {
    isLoading();
    final authResult =
        await _authService.logInWithCredentials(username, password);

    authResult
      ..mapSuccess((_) => isLogin())
      ..mapError((failure) => isError(failure));
  }

  Future<void> onValidate() async {
    if (_authService.isLoggedIn()) {
      isLogin();
    } else {
      isLogOut();
    }
  }

  Future<void> logOut() async {
    await _authService.onLogout();
    isLogOut();
  }

  void isLogin() => isSuccess(AuthStateAuthenticated());

  void isLogOut() => isSuccess(AuthStateUnauthenticated());

  void isUnknown() => isSuccess(AuthStateUnknown());
}
