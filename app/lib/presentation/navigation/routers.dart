import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/login/login_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/sign_up/sign_up_page.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/splash/splash_page.dart';
import 'package:go_router/go_router.dart';

class Routers {
  static GoRouter authRouter = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        name: "login",
        path: "/login",
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
        name: "home",
        path: "/home",
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
