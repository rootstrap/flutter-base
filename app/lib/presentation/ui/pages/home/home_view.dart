import 'package:app/main/init.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';

class HomeView extends StatelessWidget {
  /// Given this is a global cubit, we can access it directly from getIt
  /// otherwise use context.read<AuthCubit>() to read the Cubit under that context
  AuthCubit get _authCubit => getIt();

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _authCubit.logOut(),
            icon: const Icon(Icons.logout),
          ),
          const AppThemeSwitch(),
        ],
      ),
      body: const Text('Home Page'),
    );
  }
}
