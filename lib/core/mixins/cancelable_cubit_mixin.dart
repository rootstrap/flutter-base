import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CancelableCubitMixin<T> on Cubit<T> {
  List<CancelableOperation?> operations = [];

  Future<E> toCancelable<E>(Future<E> future) {
    final cancelable = CancelableOperation.fromFuture(future);
    operations.add(cancelable);
    return cancelable.value;
  }

  @override
  Future<void> close() {
    for (final operation in operations) {
      operation?.cancel();
    }
    return super.close();
  }
}