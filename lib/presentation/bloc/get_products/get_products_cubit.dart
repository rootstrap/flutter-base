import 'package:flutter_base_rootstrap/core/mixins/cancelable_cubit_mixin.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/domain/errors/get_products_error.dart';
import 'package:flutter_base_rootstrap/domain/models/product.dart';
import 'package:flutter_base_rootstrap/domain/use_cases/get_products_use_case.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/get_products/get_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetProductsCubit extends Cubit<GetProductsState> with CancelableCubitMixin {
  final GetProductsUseCase _getProductsUseCase;

  GetProductsCubit(this._getProductsUseCase) : super(GetProductsStateIdle()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    emit(GetProductsStateLoading());
    final result = await toCancelable(_getProductsUseCase.getProducts());
    switch (result) {
      case TSuccess<List<Product>, GetProductsError> e:
        emit(GetProductsStateSuccess(e.data));
      case TError<List<Product>, GetProductsError> e:
        emit(handleError(e.error));
    }
  }

  GetProductsState handleError(GetProductsError? error) {
    return switch (error) {
      EmptyListError _ => GetProductsStateEmpty(),
      DataError e => GetProductsStateError(e.failure),
      _ => GetProductsStateError(),
    };
  }
}
