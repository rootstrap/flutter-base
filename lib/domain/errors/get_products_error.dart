import 'package:flutter_base_rootstrap/core/failure/failure.dart';

abstract class GetProductsError {}

class EmptyListError extends GetProductsError {}

class DataError extends GetProductsError {
  final Failure failure;
  DataError(this.failure);
}
