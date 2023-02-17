import 'resource.dart';

abstract class ResultType<T, E> {}

class TSuccess<T, E> extends ResultType<T, E> {
  final T data;

  TSuccess(this.data);
}

class TError<T, E> extends ResultType<T, E> {
  final E? error;

  TError(this.error);
}

extension ResultTypeExtension<T, E> on ResultType<T, E> {
  void when({
    required Function(T data) onSuccess,
    required Function(E error) onError,
  }){
    Object result = this;
    if (result is TSuccess) {
      onSuccess(result.data);
    } else if (result is TError) {
      onError(result.error);
    }
  }

  Stream<Resource<V, B>> toStream<V, B>({
    required Stream<Resource<V, B>> Function(T data) success,
    required Stream<Resource<V, B>> Function(E error) error,
  }) async* {
    Object result = this;
    if (result is TSuccess) {
      yield* success(result.data);
    } else if (result is TError) {
      yield* error(result.error);
    }
  }

  ResultType<V, B> map<V, B>({
    required ResultType<V, B> Function(T data) success,
    required ResultType<V, B> Function(E error) error,
  }) {
    Object result = this;
    if (result is TSuccess) {
      return success(result.data);
    } else if (result is TError) {
      return error(result.error);
    }
    return TError(null);
  }

  ResultType<V, E> mapSuccess<V>(V Function(T data) success) {
    Object result = this;
    if (result is TSuccess) {
      return TSuccess(success(result.data));
    } else if (result is TError) {
      return TError(result.error);
    }
    return TError(null);
  }

  ResultType<T, B> mapError<B>(B? Function(E error) error) {
    Object result = this;
    if (result is TSuccess) {
      return TSuccess(result.data);
    } else if (result is TError) {
      return TError(error(result.error));
    }
    return TError(null);
  }
}
