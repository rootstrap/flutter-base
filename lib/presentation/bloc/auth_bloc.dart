import 'package:bloc/bloc.dart';
import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';

class AuthBloc extends Cubit<AuthState> {
  Preferences get preferences => getIt();

  AuthBloc() : super(AuthState.loading) {
    checkAuthState();
  }

  //TODO: dummy example
  void checkAuthState() async {
    await Future.delayed(const Duration(seconds: 5));
    emit(AuthState.loggedIn);
  }

  void logout() => emit(AuthState.loggedOut);
}

enum AuthState { loggedIn, loading, loggedOut }
