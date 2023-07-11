import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/domain/bloc/app/app_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/login/login_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/login/login_state.dart';
import 'package:flutter_base_rootstrap/domain/models/theme_type.dart';
import 'package:flutter_base_rootstrap/presentation/ui/custom/app_theme_switch.dart';
import 'package:flutter_base_rootstrap/presentation/ui/custom/loading_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
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
                      context.read<LoginCubit>().onSubmitted('Rootstrap', '12345678');
                    },
                  ),
                ),
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
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return LoadingScreen(
          isLoading: state is LoginStateLoading,
        );
      },
    );
  }
}


