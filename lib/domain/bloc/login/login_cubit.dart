import 'package:flutter_base_rootstrap/core/failure/failure.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/domain/bloc/login/login_state.dart';
import 'package:flutter_base_rootstrap/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginStateIdle());

  void onSubmitted(String username, String password) {
    emit(LoginStateLoading());
    final result = _authRepository.login(username, password);
    switch (result) {
      case TSuccess<void, Failure> _:
        emit(LoginStateSuccess());
      case TError<void, Failure> _:
        emit(LoginStateError());
    }
  }
}
