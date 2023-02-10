import '../../core/failure/failure.dart';
import '../../core/result_type.dart';
import '../models/product.dart';

abstract class ProductRepository {
  Future<ResultType<List<Product>, Failure>> getProducts();
}
