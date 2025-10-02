import 'package:common/core/failure/failure.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/base_bloc_state.dart';
import 'package:domain/bloc/auth/auth_state.dart';

class AuthCubit extends BaseBlocState<AuthState, Failure> {
  AuthCubit() : super(Success(AuthStateUnknown()));

  void isLogin() {
    isSuccess(AuthStateAuthenticated());
  }

  void isLogOut() {
    isSuccess(AuthStateUnauthenticated());
  }

  void isUnknown() {
    isSuccess(AuthStateUnknown());
  }
}
