import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/domain/repositories/product_repository.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/get_products/get_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsRepoCubit extends Cubit<GetProductsState> {
  final ProductRepository _productRepository;

  GetProductsRepoCubit(this._productRepository) : super(GetProductsStateIdle()) {
    fetchProducts();
  }

  void fetchProducts() async {
    emit(GetProductsStateLoading());
    final result = await _productRepository.getProducts();
    result.when(
      onSuccess: (products) {
        if (products.isEmpty) {
          emit(GetProductsStateEmpty());
        } else {
          emit(GetProductsStateSuccess(products));
        }
      },
      onError: (e) {
        emit(GetProductsStateError(e));
      },
    );
  }
}
