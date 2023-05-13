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
            return switch (state) {
              GetProductsStateLoading _ => const ProductsLoading(),
              GetProductsStateEmpty _ => const ProductsEmptyWidget(),
              GetProductsStateSuccess e => ProductsListWidget(products: e.products),
              GetProductsStateError e => FailureWidget(
                  failure: e.failure,
                  onRetry: () => context.read<GetProductsRepoCubit>().fetchProducts(),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
