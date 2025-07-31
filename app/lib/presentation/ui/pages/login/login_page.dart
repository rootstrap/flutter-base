import 'package:app/main/init.dart';
import 'package:app/presentation/themes/app_themes.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:app/presentation/ui/custom/loading_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/service/notification_service.dart';

class LoginPage extends StatelessWidget {
  AuthService get _authService => getIt();

  NotificationService get _notificationService => getIt();

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          backgroundColor: context.theme.colorScheme.background,
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
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Success notification'),
                    onPressed: () {
                      _notificationService.notify(
                        'Success message',
                        NotificationStatus.success,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Error notification'),
                    onPressed: () {
                      _notificationService.notify(
                        'Error message',
                        NotificationStatus.error,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Information notification'),
                    onPressed: () {
                      _notificationService.notify(
                        'Information message',
                        NotificationStatus.information,
                      );
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
    return BlocBuilder<AuthCubit, Resource>(
      builder: (context, state) {
        return LoadingScreen(
          isLoading: state is Loading,
        );
      },
    );
  }
}
