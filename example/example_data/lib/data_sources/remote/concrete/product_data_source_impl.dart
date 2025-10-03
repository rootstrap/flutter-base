import 'package:common/core/failure/failure.dart';
import 'package:common/core/failure/failure_mapper.dart';
import 'package:common/core/result_type.dart';
import 'package:dio/dio.dart';

import '../../../models/product_entity.dart';
import '../abstract/product_data_source.dart';

class ProductDataSourceImpl extends ProductDataSource {
  final Dio _dio;

  ProductDataSourceImpl(this._dio);

  @override
  Future<ResultType<List<ProductEntity>, Failure>> getProducts() async {
    try {
      final response = await _dio.get(NetworkConstants.productsPath);
      final products = (response.data['products'] as List)
          .map((e) => ProductEntity.fromMap(e))
          .toList();
      return TSuccess(products);
    } on DioException catch (e) {
      return TError(e.toFailure());
    } catch (e) {
      return TError(UnexpectedFailure(e.toString()));
    }
  }
}

class NetworkConstants {
  static const productsPath = "/products";
  static const baseUrl = "http://www.example.com";
}
