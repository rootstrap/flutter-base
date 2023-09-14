import 'package:app/main/init.dart';
import 'package:app/presentation/resources/animations.dart';
import 'package:app/presentation/resources/resources.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:app/presentation/ui/custom/loading_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  AuthService get _authService => getIt();

  const LoginPage({Key? key}) : super(key: key);

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
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "New",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(
                      duration: 1.seconds,
                      begin: 0.5,
                    ),
                const SizedBox(height: 16),
                Text(
                  "Before",
                  style: Theme.of(context).textTheme.titleLarge,
                )
                    .animate()
                    .fade(
                      duration: const Duration(milliseconds: 1000),
                      begin: 0.5,
                    )
                    .swap(
                      duration: 1000.ms,
                      builder: (_, __) => Text(
                        "After",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                const SizedBox(height: 16),
                Animate().toggle(
                  duration: 2.seconds,
                  builder: (_, value, __) => AnimatedContainer(
                    decoration: BoxDecoration(
                      color: value ? Colors.red : Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    padding: const EdgeInsets.all(8),
                    duration: 1.seconds,
                    child: Text(
                      value ? "Before" : "After",
                      style: Theme.of(context).textTheme.titleLarge,
                    ).animate().fadeIn(duration: 1.seconds),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Sample animation in 5 seconds: ",
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate().custom(
                      duration: 5.seconds,
                      builder: (context, value, child) => Container(
                        decoration: BoxDecoration(
                          color: Color.lerp(Colors.red, Colors.blue, value),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            child,
                            const SizedBox(width: 8),
                            Text(
                              "${(value * 5).toInt()}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
                Text(
                  'Pre loaded animation',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate(effects: AppAnimations.transitionIn),
                const SizedBox(height: 16),
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
                  )
                      .animate()
                      .shimmer(duration: Duration(milliseconds: 1000)),
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
    return BlocBuilder<SessionCubit, Resource>(
      builder: (context, state) {
        return LoadingScreen(
          isLoading: state is Loading,
        );
      },
    );
  }
}
