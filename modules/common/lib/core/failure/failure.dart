sealed class Failure {
  String? message;

  Failure(this.message);
}

class Exception extends Failure {
  Exception([String? message]) : super(message);
}

class ConnectionFailure extends Failure {
  ConnectionFailure([String? message]) : super(message);
}

class SocketTimeOutFailure extends Failure {
  SocketTimeOutFailure([String? message]) : super(message);
}

class HttpFailure extends Failure {
  final int? code;

  HttpFailure(this.code, {String? name}) : super(name);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure([String? message]) : super(message);
}
