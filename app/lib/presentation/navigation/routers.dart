import 'package:app/main/init.dart';
import 'package:app/presentation/ui/pages/home/home_page.dart';
import 'package:app/presentation/ui/pages/login/login_page.dart';
import 'package:app/presentation/ui/pages/sign_up/sign_up_page.dart';
import 'package:app/presentation/ui/pages/splash/splash_page.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  auth,
  login,
  signUp,
  app,
  home;

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
            listener: (_, state) {
              if (state is RSuccess) {
                switch (state.data) {
                  case AuthStateAuthenticated _:
                    Routes.app.nav();
                    break;
                  case AuthStateUnauthenticated _:
                    Routes.auth.nav();
                    break;
                  case _:
                }
              }
            },
            child: const SplashPage(instant: true),
          );
        },
        routes: [
          GoRoute(
            name: Routes.auth.name,
            path: Routes.auth.path,
            redirect: (context, state) {
              if (getIt<AuthCubit>().isLoggedIn()) {
                return '${Routes.app.path}${Routes.home.path}';
              }

              return '${Routes.auth.path}${Routes.login.path}';
            },
            routes: [
              GoRoute(
                name: Routes.login.name,
                path: Routes.login.subPath,
                builder: (context, state) => const LoginPage(),
              ),
              GoRoute(
                name: Routes.signUp.name,
                path: Routes.signUp.subPath,
                builder: (context, state) => const SignUpPage(),
              ),
            ],
          ),
          GoRoute(
            name: Routes.app.name,
            path: Routes.app.path,
            builder: (context, state) => const SplashPage(),
            redirect: (context, state) {
              if (!getIt<AuthCubit>().isLoggedIn()) {
                return '${Routes.auth.path}${Routes.login.path}';
              }

              return '${Routes.app.path}${Routes.home.path}';
            },
            routes: [
              GoRoute(
                name: Routes.home.name,
                path: Routes.home.subPath,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
