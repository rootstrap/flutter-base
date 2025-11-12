import 'package:app/main/init.dart';
import 'package:common/core/failure/failure.dart';
import 'package:common/core/resource.dart';
import 'package:domain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:app/presentation/ui/custom/failure_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  AuthService get _authService => getIt();

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _authService.onLogout(),
            icon: const Icon(Icons.logout),
          ),
          const AppThemeSwitch(),
        ],
      ),
      body: BlocBuilder<GetProductsCubit, Resource>(
        builder: (context, state) {
          return switch (state) {
            RLoading _ => const ProductsLoading(),
            RSuccess<List<Product>> e => ProductsListWidget(products: e.data),
            RError<Failure> e => FailureWidget(
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
