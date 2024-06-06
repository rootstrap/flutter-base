import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';

import '../../../models/product_entity.dart';

abstract class ProductDataSource {
  Future<ResultType<List<ProductEntity>, Failure>> getProducts();
}
