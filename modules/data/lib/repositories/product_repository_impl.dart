import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:data/data_sources/remote/abstract/product_data_source.dart';
import 'package:domain/models/product.dart';
import 'package:domain/repositories/product_repository.dart';

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
      (products) => products.map((e) => Product.fromEntity(e)).toList(),
    );
  }
}
