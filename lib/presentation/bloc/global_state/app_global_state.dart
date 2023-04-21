import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/themes/local_theme.dart';

class AppGlobalState {
  final AuthState authState;
  final LocalTheme? appTheme;
  final Locale? locale;

  AppGlobalState({
    this.authState = AuthState.loading,
    this.appTheme,
    this.locale,
  });
}

enum AuthState { loggedIn, loading, loggedOut }

extension AuthStateExt on AuthState {
  static Map<String, AuthState> authValues = {
    AuthState.loggedIn.toString(): AuthState.loggedIn,
    AuthState.loggedOut.toString(): AuthState.loggedOut,
  };

  static AuthState getStateFromValue(String? fromValue) =>
      authValues[fromValue ?? AuthState.loggedOut.toString()]!;
}

extension AppGlobalStateExt on AppGlobalState {
  AppGlobalState copyWith({AuthState? newAuthState, LocalTheme? newAppTheme}) =>
      AppGlobalState(
        authState: newAuthState ?? authState,
        appTheme: newAppTheme ?? appTheme,
      );
}
