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

  void nav({Object? extra}) {
    Routers.authRouter.goNamed(
      name,
      extra: extra,
    );
  }

  static GoRouter get router => Routers.authRouter;
}

class Routers {
  static GoRouter authRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocListener<AuthCubit, Resource>(
            listenWhen: (previous, current) => current is RSuccess,
            listener: (_, state) {
              if (state is RSuccess) {
                switch (state.data) {
                  case AuthStateAuthenticated _:
                    debugPrint('User is authenticated');
                    Routes.app.nav();
                    break;
                  case AuthStateUnauthenticated _:
                    debugPrint('User is unauthenticated');
                    Routes.auth.nav();
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
            redirect: (context, state) {
              if (context.read<AuthCubit>().isLoggedIn()) {
                return Routes.app.path;
              }
              return null;
            },
            routes: [
              GoRoute(
                name: Routes.auth.name,
                path: Routes.auth.path,
                builder: (context, state) => const LoginPage(),
              ),
              GoRoute(
                name: Routes.signup.name,
                path: '${Routes.auth.path}${Routes.signup.path}',
                builder: (context, state) => const SignUpPage(),
              ),
            ],
          ),
          ShellRoute(
            builder: (context, state, child) => child,
            redirect: (context, state) {
              if (!context.read<AuthCubit>().isLoggedIn()) {
                return Routes.auth.path;
              }
              return null;
            },
            routes: [
              GoRoute(
                name: Routes.app.name,
                path: Routes.app.path,
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                name: Routes.placeholder.name,
                path: "${Routes.app.path}${Routes.placeholder.path}",
                builder: (context, state) => const Placeholder(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
