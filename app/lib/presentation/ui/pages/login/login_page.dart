import 'package:app/main/init.dart';
import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/themes/app_themes.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:app/presentation/ui/custom/loading_screen.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../custom/environment_selector.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  AuthCubit get _authCubit => getIt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppThemeSwitch(),
                SizedBox(height: spacing.m),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      _authCubit.login(
                        'Rootstrap',
                        '12345678',
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing.xxxl),
                if (kDebugMode) ...[
                  EnvironmentSelector(),
                ],
              ],
            ),
          ),
          const _Loading(),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, Resource>(
      builder: (context, state) {
        if (state is! RLoading) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.black.withAlpha(50),
          width: double.maxFinite,
          height: double.maxFinite,
          child: const LoadingScreen(),
        );
      },
    );
  }
}
