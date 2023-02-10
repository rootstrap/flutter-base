abstract class Resource<T, E> {}

class RLoading<T, E> extends Resource<T, E> {}

class RError<T, E> extends Resource<T, E> {
  final E error;

  RError(this.error);
}

class RSuccess<T, E> extends Resource<T, E> {
  final T data;

  RSuccess(this.data);
}

extension ResourceExtension<T, E> on Resource<T, E> {
  void when({
    required Function(T data) onSuccess,
    required Function(E error) onError,
    required Function() onLoading,
  }) {
    Object result = this;
    if (result is RSuccess) {
      onSuccess(result.data);
    } else if (result is RError) {
      onError(result.error);
    } else if (result is RLoading) {
      onLoading();
    }
  }
}
