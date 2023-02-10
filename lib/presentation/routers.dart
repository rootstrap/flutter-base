import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_rootstrap/presentation/ui/components/cookies.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/main_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/notification_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/post_details_screen.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/settings_screen.dart';
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
            child: HomePage(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            name: "main",
            path: "/main",
            builder: (context, state) => const MainPage(),
            routes: [
              GoRoute(
                name: "postDetails",
                path: "post/:id",
                builder: (context, state) => PostDetailsPage(
                  postId: state.params["id"] ?? "",
                ),
              ),
            ],
          ),
          GoRoute(
            name: "notifications",
            path: "/notifications",
            builder: (context, state) => const NotificationPage(),
          ),
        ],
      ),
      //ROUTES for settings
      ShellRoute(
        builder: (context, state, child) {
          return Cookies(child: child);
        },
        routes: [
          GoRoute(
            name: "settings",
            path: "/settings",
            builder: (context, state) {
              return Container();
            },
            routes: [
              GoRoute(
                name: "profile_sub",
                path: "profile_sub",
                builder: (context, state) {
                  return SettingsPage(
                    profileName:
                        state.queryParams['profileName']?.toString() ?? "",
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: "profile",
            path: "/profile",
            builder: (context, state) {
              return SettingsPage(
                profileName: state.queryParams['profileName']?.toString() ?? "",
              );
            },
          ),
          GoRoute(
            name: "password",
            path: "/password",
            builder: (context, state) => const ResetPasswordPage(),
          ),
        ],
      ),
    ],
  );
}
