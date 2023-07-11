sealed class LoginState {}

class LoginStateIdle extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateSuccess extends LoginState {}

class LoginStateError extends LoginState {}
