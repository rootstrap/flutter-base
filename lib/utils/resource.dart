abstract class Resource<T, E> {}

class Success<T, E> extends Resource<T, E> {
  final T data;

  Success(this.data);
}

class Failure<T, E> extends Resource<T, E> {
  final E error;

  Failure(this.error);
}

extension ResourceExtension<T, E> on Resource<T, E> {
  void when({
    required Function(T data) onSuccess,
    required Function(E error) onError,
  }) {
    Object result = this;

    if (result is Success) {
      onSuccess(result.data);
    } else if (result is Failure) {
      onError(result.error);
    }
  }
}
