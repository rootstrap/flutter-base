import 'package:flutter_base_rootstrap/core/failure/failure.dart';
import 'package:flutter_base_rootstrap/core/mixins/cancelable_cubit_mixin.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/domain/bloc/get_products/get_products_state.dart';
import 'package:flutter_base_rootstrap/domain/models/product.dart';
import 'package:flutter_base_rootstrap/domain/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsCubit extends Cubit<GetProductsState> with CancelableCubitMixin {
  final ProductRepository _productRepository;

  GetProductsCubit(this._productRepository) : super(GetProductsStateLoading());

  void fetchProducts() async {
    emit(GetProductsStateLoading());
    final result = await toCancelable(_productRepository.getProducts());
    switch (result) {
      case TSuccess<List<Product>, Failure> e:
        emit(GetProductsStateSuccess(e.data));
      case TError<List<Product>, Failure> e:
        emit(GetProductsStateError(e.error));
    }
  }
}
