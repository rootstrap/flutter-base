import 'package:app/presentation/ui/pages/home/home_page.dart';
import 'package:app/presentation/ui/pages/login/login_page.dart';
import 'package:app/presentation/ui/pages/sign_up/sign_up_page.dart';
import 'package:app/presentation/ui/pages/splash/splash_page.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/auth/auth_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  auth,
  login,
  signup,
  app,
  home,
  placeholder;

  String get path => '/$name';
  String get subPath => name;

  void nav(BuildContext context, {Object? extra}) {
    context.router.goNamed(
      name,
      extra: extra,
    );
  }

  static GoRouter init(BuildContext context, {String? initialLocation}) =>
      Routers.appRouter(context, initialLocation: initialLocation);
}

extension ContextOnRouter on BuildContext {
  GoRouter get router => GoRouter.of(this);
}

class Routers {
  static GoRouter appRouter(
    BuildContext context, {
    String? initialLocation,
  }) =>
      GoRouter(
        initialLocation: initialLocation ??
            (context.read<AuthCubit>().isLoggedIn()
                ? Routes.app.path
                : Routes.auth.path),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return BlocListener<AuthCubit, Resource>(
                listenWhen: (previous, current) => current is RSuccess,
                listener: (_, appState) {
                  if (appState is RSuccess) {
                    switch (appState.data) {
                      case AuthStateAuthenticated _:
                        debugPrint('User is authenticated: ${state.fullPath}');
                        if (state.fullPath?.contains(Routes.app.path) ??
                            false) {
                          // Already navigating to app, do nothing
                          return;
                        }
                        debugPrint('Navigating to app route');
                        Routes.app.nav(context);
                        break;
                      case AuthStateUnauthenticated _:
                        debugPrint(
                            'User is unauthenticated: ${state.fullPath}');
                        if (state.fullPath?.contains(Routes.auth.path) ??
                            false) {
                          // Already navigating to auth, do nothing
                          return;
                        }
                        debugPrint('Navigating to auth route');
                        Routes.auth.nav(context);
                        break;
                      case _:
                    }
                  }
                },
                child: const SplashPage(),
              );
            },
            routes: [
              ShellRoute(
                builder: (context, state, child) => child,
                routes: [
                  GoRoute(
                    name: Routes.auth.name,
                    path: Routes.auth.path,
                    redirect: (context, state) {
                      if (context.read<AuthCubit>().isLoggedIn()) {
                        return Routes.app.path;
                      }
                      return null;
                    },
                    builder: (context, state) => const LoginPage(),
                    routes: [
                      GoRoute(
                        name: Routes.signup.name,
                        path: Routes.signup.subPath,
                        builder: (context, state) => const SignUpPage(),
                      ),
                    ],
                  ),
                ],
              ),
              ShellRoute(
                builder: (context, state, child) => child,
                routes: [
                  GoRoute(
                    name: Routes.app.name,
                    path: Routes.app.path,
                    redirect: (context, state) {
                      if (!context.read<AuthCubit>().isLoggedIn()) {
                        return Routes.auth.path;
                      }
                      return null;
                    },
                    builder: (context, state) => const HomePage(),
                    routes: [
                      GoRoute(
                        name: Routes.placeholder.name,
                        path: Routes.placeholder.subPath,
                        builder: (context, state) => const Placeholder(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
