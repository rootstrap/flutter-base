
import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';

import '../models/product.dart';

abstract class ProductRepository {
  Future<ResultType<List<Product>, Failure>> getProducts();
}
