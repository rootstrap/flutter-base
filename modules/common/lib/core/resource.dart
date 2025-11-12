class Resource<T> {
  RState? state;
  T? data;
  Exception? exception;

  Resource({this.state, this.data, this.exception});

  RSuccess<T> isSuccess(T data, {Exception? exception}) =>
      RSuccess<T>(data: data);

  RLoading<T> isLoading() => RLoading<T>(data: data);

  RError<T> isError({Exception? exception}) => RError<T>(
        exception: exception,
        data: data,
      );
}

class RLoading<T> extends Resource<T> {
  RLoading({super.state = RState.loading, super.data});
}

class RSuccess<T> extends Resource<T> {
  RSuccess({super.state = RState.success, required super.data});
}

class RError<T> extends Resource<T> {
  RError({super.state = RState.error, super.data, required super.exception});
}

enum RState {
  loading,
  success,
  error;
}
