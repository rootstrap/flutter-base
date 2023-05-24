import '../../../core/failure/failure.dart';
import '../../../domain/models/product.dart';

sealed class GetProductsState {}

class GetProductsStateLoading extends GetProductsState {}

class GetProductsStateError extends GetProductsState {
  final Failure? failure;

  GetProductsStateError([this.failure]);
}

class GetProductsStateSuccess extends GetProductsState {
  final List<Product> products;

  GetProductsStateSuccess(this.products);
}
