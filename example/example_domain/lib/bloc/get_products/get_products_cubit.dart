import 'package:common/core/failure/failure.dart';
import 'package:common/core/mixins/cancelable_cubit_mixin.dart';
import 'package:common/core/resource.dart';
import 'package:example_domain/bloc/BaseBlocState.dart';
import 'package:example_domain/models/product.dart';

class GetProductsCubit extends BaseBlocState<List<Product>, Failure>
    with CancelableCubitMixin {
  GetProductsCubit() : super(Loading());
}
