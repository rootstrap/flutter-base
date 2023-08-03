import 'package:common/core/failure/failure.dart';
import 'package:common/core/mixins/cancelable_cubit_mixin.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/BaseBlocState.dart';
import 'package:domain/models/product.dart';

class GetProductsCubit extends BaseBlocState<List<Product>, Failure>
    with CancelableCubitMixin {
  GetProductsCubit() : super(Loading());
}
