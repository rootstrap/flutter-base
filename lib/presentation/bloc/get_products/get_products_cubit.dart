import 'package:flutter_base_rootstrap/core/resource.dart';
import 'package:flutter_base_rootstrap/domain/errors/get_products_error.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/get_products/get_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_products_use_case.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  final GetProductsUseCase _getProductsUseCase;

  GetProductsCubit(this._getProductsUseCase) : super(GetProductsStateIdle()){
    fetchProducts();
  }

  void fetchProducts() {
    _getProductsUseCase.getProducts().listen((event) {
      event.when(
        onSuccess: (products) => emit(GetProductsStateSuccess(products)),
        onError: (error) => handleError(error),
        onLoading: () => emit(GetProductsStateLoading()),
      );
    });
  }

  void handleError(GetProductsError error) {
    if (error is EmptyListError) {
      emit(GetProductsStateEmpty());
      return;
    }
    if (error is DataError) {
      emit(GetProductsStateError(error.failure));
      return;
    }
  }
}
