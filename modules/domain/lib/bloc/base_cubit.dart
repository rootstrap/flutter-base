import 'package:common/core/resource.dart';
import 'package:common/core/result_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseCubit<T> extends Cubit<Resource<T>> {
  BaseCubit(super.initialState);

  void isLoading() {
    emit(state.isLoading());
  }

  void isSuccess(T data) {
    emit(state.isSuccess(data));
  }

  void isError(Exception? error) {
    emit(state.isError(exception: error));
  }

  void onResult(ResultType<T> result) {
    switch (result) {
      case TSuccess<T> e:
        isSuccess(e.data);
      case TError<T> e:
        isError(e.error);
    }
  }
}
