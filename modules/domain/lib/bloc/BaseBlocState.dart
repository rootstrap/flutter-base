import 'package:common/core/mixins/cancelable_cubit_mixin.dart';
import 'package:common/core/resource.dart';
import 'package:common/core/result_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBlocState<T, E> extends Cubit<Resource> with CancelableCubitMixin {
  BaseBlocState(super.initialState);

  void isLoading() {
    emit(Loading());
  }

  void isSuccess(T data) {
    emit(Success(data));
  }

  void isError(E? error) {
    emit(Error(exception: error));
  }

  void onResult(ResultType<T, E> result) {
    switch (result) {
      case TSuccess<T, E> e:
        isSuccess(e.data);
      case TError<T, E> e:
        isError(e.error);
    }
  }
}
