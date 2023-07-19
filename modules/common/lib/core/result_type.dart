sealed class ResultType<T, E> {}

class TSuccess<T, E> extends ResultType<T, E> {
  final T data;

  TSuccess(this.data);
}

class TError<T, E> extends ResultType<T, E> {
  final E? error;

  TError(this.error);
}

extension ResultTypeExtension<T, E> on ResultType<T, E> {
  ResultType<V, B> map<V, B>({
    required V Function(T data) success,
    required B? Function(E? error) error,
  }) {
    return switch (this) {
      TSuccess<T, E> e => TSuccess(success(e.data)),
      TError<T, E> e => TError(error(e.error)),
    };
  }

  ResultType<V, E> mapSuccess<V>(V Function(T data) success) {
    return switch (this) {
      TSuccess<T, E> e => TSuccess(success(e.data)),
      TError<T, E> e => TError(e.error),
    };
  }

  ResultType<T, B> mapError<B>(B? Function(E? error) error) {
    return switch (this) {
      TSuccess<T, E> e => TSuccess(e.data),
      TError<T, E> e => TError(error(e.error)),
    };
  }
}
