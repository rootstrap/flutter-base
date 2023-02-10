import 'package:flutter_base_rootstrap/domain/errors/get_products_error.dart';
import 'package:flutter_base_rootstrap/domain/repositories/product_repository.dart';

import '../../core/resource.dart';
import '../../core/result_type.dart';
import '../models/product.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Stream<Resource<List<Product>, GetProductsError>> getProducts() async* {
    yield RLoading();
    final productResult = await _productRepository.getProducts();
    yield* productResult.toStream(
      success: (products) async* {
        if (products.isEmpty) {
          yield RError(EmptyListError());
        } else {
          yield RSuccess(products);
        }
      },
      error: (failure) async* {
        yield RError(DataError(failure));
      },
    );
  }
}
