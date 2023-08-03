import 'package:common/core/failure/failure.dart';

sealed class Resource {}

class Loading extends Resource {}

class Error<E> extends Resource {
  final E? exception;

  Error({this.exception});
}

class Success<T> extends Resource {
  final T data;

  Success(this.data);
}
