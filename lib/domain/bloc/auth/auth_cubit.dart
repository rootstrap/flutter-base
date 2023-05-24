import 'dart:async';

import 'package:flutter_base_rootstrap/domain/bloc/auth/auth_state.dart';
import 'package:flutter_base_rootstrap/domain/models/auth_status.dart';
import 'package:flutter_base_rootstrap/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AuthStatus> _statusSubscription;

  AuthCubit(this._authRepository) : super(AuthStateUnknown()) {
    _statusSubscription = _authRepository.status.listen((status) => _onStatusChange(status));
  }

  void _onStatusChange(AuthStatus authStatus) {
    switch (authStatus) {
      case AuthStatus.unauthenticated:
        emit(AuthStateUnauthenticated());
      case AuthStatus.authenticated:
        emit(AuthStateAuthenticated());
      case AuthStatus.unknown:
        emit(AuthStateUnknown());
    }
  }

  void onValidate() {
    _authRepository.validate();
  }

  Future<void> onLogout() {
    return _authRepository.logout();
  }

  @override
  Future<void> close() {
    _statusSubscription.cancel();
    return super.close();
  }
}
