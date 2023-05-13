import 'package:flutter_base_rootstrap/core/failure/failure.dart';
import 'package:flutter_base_rootstrap/domain/errors/get_products_error.dart';
import 'package:flutter_base_rootstrap/domain/repositories/product_repository.dart';

import '../../core/result_type.dart';
import '../models/product.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Future<ResultType<List<Product>, GetProductsError>> getProducts() async {
    final result = await _productRepository.getProducts();
    switch (result) {
      case TSuccess<List<Product>, Failure> e:
        final products = e.data;
        if (products.isEmpty) {
          return TError(EmptyListError());
        } else {
          return TSuccess(products);
        }
      case TError<List<Product>, Failure> e:
        return TError(DataError(e.error));
    }
  }
}
