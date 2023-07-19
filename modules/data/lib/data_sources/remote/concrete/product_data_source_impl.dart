import 'package:data/data_sources/remote/abstract/product_data_source.dart';
import 'package:dio/dio.dart';
import 'package:common/core/failure/failure_mapper.dart';

import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:data/models/product_entity.dart';
import 'package:data/network/config/network_constants.dart';

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
    } on DioError catch (e) {
      return TError(e.toFailure());
    } catch (e) {
      return TError(UnexpectedFailure(e.toString()));
    }
  }
}
