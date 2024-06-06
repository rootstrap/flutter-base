import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:example_domain/repositories/product_repository.dart';

import '../data_sources/remote/abstract/product_data_source.dart';
import 'package:example_domain/models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _productDataSource;

  ProductRepositoryImpl(this._productDataSource);

  @override
  Future<ResultType<List<Product>, Failure>> getProducts() async {
    final productResult = await _productDataSource.getProducts();
    return productResult.mapSuccess(
      (products) => products.map((e) => Product.fromEntity(e)).toList(),
    );
  }
}
