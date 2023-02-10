import '../../../../core/failure/failure.dart';
import '../../../../core/result_type.dart';
import '../../../models/product_entity.dart';

abstract class ProductDataSource {
  Future<ResultType<List<ProductEntity>, Failure>> getProducts();
}
