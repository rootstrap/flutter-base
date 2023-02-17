import 'package:dio/dio.dart';
import 'package:flutter_base_rootstrap/core/failure/failure_mapper.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/result_type.dart';
import '../../../models/product_entity.dart';
import '../../../network/config/network_constants.dart';
import '../abstract/product_data_source.dart';

class ProductDataSourceImpl extends ProductDataSource {
  final Dio _dio;

  ProductDataSourceImpl(this._dio);

  @override
  Future<ResultType<List<ProductEntity>, Failure>> getProducts() async {
    try {
      final response = await _dio.get(NetworkConstants.productsPath);
      final products = (response.data['products'] as List).map((e) => ProductEntity.fromMap(e)).toList();
      return TSuccess(products);
    } on DioError catch (e) {
      return TError(e.toFailure());
    } catch (e) {
      return TError(UnexpectedFailure(e.toString()));
    }
  }
}
