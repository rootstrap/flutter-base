sealed class Resource<T, E> {}

class RLoading<T,E> extends Resource<T, E> {}

class RError<T, E> extends Resource<T, E> {
  final E error;

  RError(this.error);
}

class RSuccess<T,E> extends Resource<T,E> {
  final T data;
  RSuccess(this.data);
}
