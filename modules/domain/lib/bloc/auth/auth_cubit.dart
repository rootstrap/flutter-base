import 'package:common/core/resource.dart';
import 'package:domain/bloc/base_cubit.dart';
import 'package:domain/bloc/auth/auth_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit() : super(RSuccess(data: AuthStateUnknown()));

  void isLogin() => isSuccess(AuthStateAuthenticated());

  void isLogOut() => isSuccess(AuthStateUnauthenticated());

  void isUnknown() => isSuccess(AuthStateUnknown());
}
