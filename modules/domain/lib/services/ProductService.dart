import 'package:common/core/mixins/cancelable_cubit_mixin.dart';
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:domain/repositories/product_repository.dart';

class ProductService {
  final ProductRepository _productRepository;
  final GetProductsCubit _getProductsCubit;

  ProductService(this._productRepository, this._getProductsCubit);

  GetProductsCubit productsCubit() => _getProductsCubit;

  void fetchProducts() async {
    _getProductsCubit.isLoading();
    final result =
        await _getProductsCubit.toCancelable(_productRepository.getProducts());
    _getProductsCubit.onResult(result);
  }
}
