import 'package:domain/models/auth_status.dart';

sealed class AuthState {
  final AuthStatus authStatus;
  AuthState._(this.authStatus);
}

class AuthStateUnknown extends AuthState {
  AuthStateUnknown() : super._(AuthStatus.unknown);
}

class AuthStateAuthenticated extends AuthState {
  AuthStateAuthenticated() : super._(AuthStatus.authenticated);
}

class AuthStateUnauthenticated extends AuthState {
  AuthStateUnauthenticated() : super._(AuthStatus.unauthenticated);
}
