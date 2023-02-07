import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/ui/components/cookies.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/main_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/notification_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/post_details_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/settings_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/auth_login_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/auth_reset_password_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/auth_sign_up_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/onboarding/onboarding_page.dart';
import 'package:go_router/go_router.dart';

final mainNavigatorKey = GlobalKey<NavigatorState>();
final onBoardingNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
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
        GoRoute(
          name: "settings",
          path: "/settings",
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: onBoardingNavigatorKey,
      builder: (context, state, child) {
        return Cookies(
          child: OnBoardingPage(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: "/auth",
          redirect: (context, state) => "/auth/logIn",
          routes: [
            GoRoute(
              name: "login",
              path: "logIn",
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              name: "signUp",
              path: "signUp",
              builder: (context, state) => const SignUpPage(),
            ),
            GoRoute(
              name: "passwordReset",
              path: "passwordReset",
              builder: (context, state) => const ResetPasswordPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
