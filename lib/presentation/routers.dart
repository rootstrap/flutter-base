import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_rootstrap/presentation/ui/components/cookies.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/auth_login_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/auth_reset_password_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/auth_sign_up_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/splash_screen.dart';
import 'package:go_router/go_router.dart';

final mainNavigatorKey = GlobalKey<NavigatorState>();
final onBoardingNavigatorKey = GlobalKey<NavigatorState>();

class Routers {
  static GoRouter onBoardingRouter(AuthState authState) => GoRouter(
        initialLocation: authState == AuthState.loading ? "/splash" : "/logIn",
        navigatorKey: onBoardingNavigatorKey,
        routes: [
          GoRoute(
            name: "login",
            path: "/logIn",
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            name: "splash",
            path: "/splash",
            builder: (context, state) => const SplashPage(),
          ),
          GoRoute(
            name: "signUp",
            path: "/signUp",
            builder: (context, state) => const SignUpPage(),
          ),
          GoRoute(
            name: "passwordReset",
            path: "/passwordReset",
            builder: (context, state) => const ResetPasswordPage(),
          ),
        ],
      );

    static GoRouter mainRouter = GoRouter(
      initialLocation: "/main",
      routes: [
        ShellRoute(
          navigatorKey: mainNavigatorKey,
          builder: (context, state, child) {
            return Cookies(
              child: HomeCorePage(
                child: child,
              ),
            );
          },
          routes: [
            GoRoute(
              name: "main",
              path: "/main",
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
      ],
    );
}
