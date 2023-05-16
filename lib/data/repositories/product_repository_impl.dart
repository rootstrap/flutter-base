import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_base_rootstrap/core/failure/failure.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/data/data_sources/remote/abstract/product_data_source.dart';
import 'package:flutter_base_rootstrap/data/mappers/product_mapper.dart';
import 'package:flutter_base_rootstrap/domain/models/product.dart';
import 'package:flutter_base_rootstrap/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource _productDataSource;

  ProductRepositoryImpl(this._productDataSource);

  @override
  Future<ResultType<List<Product>, Failure>> getProducts() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return TError(ConnectionFailure());
    }
    final productResult = await _productDataSource.getProducts();
    return productResult.mapSuccess(
      (products) => products.map((e) => e.toDomain()).toList(),
    );
  }
}
