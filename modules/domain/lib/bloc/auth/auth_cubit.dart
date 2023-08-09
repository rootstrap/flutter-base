import 'package:common/core/failure/failure.dart';
import 'package:common/core/resource.dart';
import 'package:common/core/result_type.dart';
import 'package:domain/bloc/BaseBlocState.dart';
import 'package:domain/bloc/auth/auth_state.dart';

class SessionCubit extends BaseBlocState<AuthState, Failure> {
  SessionCubit() : super(Success(AuthStateUnknown()));

  void isLogin() {
    isSuccess(AuthStateAuthenticated());
  }

  void isLogOut() {
    isSuccess(AuthStateUnauthenticated());
  }

  void isUnknown() {
    isSuccess(AuthStateUnknown());
  }

  @override
  void onResult(ResultType<void, Failure> result) {
    switch (result) {
      case TSuccess<void, Failure> _:
        isLogin();
      case TError<void, Failure> _:
        isError(result.error);
    }
  }
}
