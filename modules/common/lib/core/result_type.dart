sealed class ResultType<T> {}

class TSuccess<T> extends ResultType<T> {
  final T data;

  TSuccess(this.data);
}

class TError<T> extends ResultType<T> {
  final Exception? error;

  TError(this.error);
}

extension ResultTypeExtension<T> on ResultType<T> {
  ResultType<T> map({
    required T Function(T data) success,
    required Exception? Function(Exception? error) error,
  }) {
    return switch (this) {
      TSuccess<T> e => TSuccess(success(e.data)),
      TError e => TError(error(e.error)),
    };
  }

  ResultType<T> mapSuccess(Function(T data) success) {
    return switch (this) {
      TSuccess<T> e => TSuccess(success(e.data)),
      TError e => TError(e.error),
    };
  }

  /// Invokes [error] when this is a [TError]. If the callback returns an
  /// [Exception], it replaces the original error; otherwise the original
  /// error is kept, so side-effect callbacks don't discard it.
  ResultType<T> mapError(Function(Exception? error) error) {
    return switch (this) {
      TSuccess<T> e => TSuccess(e.data),
      TError e => _mapErrorValue(error(e.error), e.error),
    };
  }

  TError<T> _mapErrorValue(dynamic mapped, Exception? original) =>
      TError(mapped is Exception ? mapped : original);
}
