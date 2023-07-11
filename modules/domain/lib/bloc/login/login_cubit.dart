import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:domain/bloc/login/login_state.dart';
import 'package:domain/repositories/auth_repository.dart';
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