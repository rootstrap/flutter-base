import 'package:app/main/init.dart';
import 'package:app/presentation/themes/app_themes.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:app/presentation/ui/custom/loading_screen.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../custom/environment_selector.dart';

class LoginPage extends StatelessWidget {
  AuthService get _authService => getIt();

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          backgroundColor: context.theme.colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppThemeSwitch(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      _authService.logInWithCredentials(
                        'Rootstrap',
                        '12345678',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                if (kDebugMode) ...[
                  EnvironmentSelector(),
                ],
              ],
            ),
          ),
        ),
        const _Loading(),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, Resource>(
      builder: (context, state) {
        return LoadingScreen(
          isLoading: state is Loading,
        );
      },
    );
  }
}
