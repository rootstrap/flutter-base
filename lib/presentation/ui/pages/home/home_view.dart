import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/get_products/get_products_state.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/get_products_repo/get_products_repo_cubit.dart';
import 'package:flutter_base_rootstrap/presentation/ui/custom/failure_widget.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/widget/products_empty_widget.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/widget/products_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widget/products_list_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: BlocBuilder<GetProductsRepoCubit, GetProductsState>(
          builder: (context, state) {
            if (state is GetProductsStateLoading) {
              return const ProductsLoading();
            }
            if (state is GetProductsStateSuccess) {
              return ProductsListWidget(products: state.products);
            }
            if (state is GetProductsStateEmpty) {
              return const ProductsEmptyWidget();
            }
            if (state is GetProductsStateError) {
              return FailureWidget(
                failure: state.failure,
                onRetry: () => context.read<GetProductsRepoCubit>().fetchProducts(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
