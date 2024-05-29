import 'package:app/main/init.dart';
import 'package:app/presentation/navigation/routers.dart';
import 'package:common/core/failure/failure.dart';
import 'package:common/core/resource.dart';
import 'package:domain/models/product.dart';
import 'package:domain/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:app/presentation/ui/custom/failure_widget.dart';
import 'package:app/presentation/ui/pages/home/widget/products_list_widget.dart';
import 'package:app/presentation/ui/pages/home/widget/products_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  AuthService get _authService => getIt();
  GoRouter get _goRouter => Routers.authRouter;

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _authService.onLogout(),
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () =>  _goRouter.go('/chat'),
            icon: const Icon(Icons.chat_bubble),
          ),
          const AppThemeSwitch(),
        ],
      ),
      body: BlocBuilder<GetProductsCubit, Resource>(
        builder: (context, state) {
          return switch (state) {
            Loading _ => const ProductsLoading(),
            Success<List<Product>> e => ProductsListWidget(products: e.data),
            Error<Failure> e => FailureWidget(
                failure: e.exception,
                onRetry: () => context.read<GetProductsCubit>(),
              ),
            _ => Container()
          };
        },
      ),
    );
  }
}
