import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/domain/bloc/auth/auth_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/get_products/get_products_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/get_products/get_products_state.dart';
import 'package:flutter_base_rootstrap/presentation/ui/custom/app_theme_switch.dart';
import 'package:flutter_base_rootstrap/presentation/ui/custom/failure_widget.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/widget/products_list_widget.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/widget/products_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().onLogout(),
            icon: const Icon(Icons.logout),
          ),
          const AppThemeSwitch(),
        ],
      ),
      body: BlocBuilder<GetProductsCubit, GetProductsState>(
        builder: (context, state) {
          return switch (state) {
            GetProductsStateLoading _ => const ProductsLoading(),
            GetProductsStateSuccess e => ProductsListWidget(products: e.products),
            GetProductsStateError e => FailureWidget(
                failure: e.failure,
                onRetry: () => context.read<GetProductsCubit>().fetchProducts(),
              ),
          };
        },
      ),
    );
  }
}
