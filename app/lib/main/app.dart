import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/di/di_init.dart';
import 'package:flutter_base_rootstrap/domain/bloc/app/app_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/app/app_state.dart';
import 'package:flutter_base_rootstrap/domain/bloc/auth/auth_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/auth/auth_state.dart';
import 'package:flutter_base_rootstrap/domain/repositories/auth_repository.dart';
import 'package:flutter_base_rootstrap/presentation/navigation/routers.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/generated/l10n.dart';
import 'package:flutter_base_rootstrap/presentation/themes/app_themes.dart';
import 'package:flutter_base_rootstrap/presentation/utils/lang_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: const AppView(),
    );
  }

  @override
  void dispose() {
    getIt<AuthRepository>().dispose();
    super.dispose();
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

  GoRouter goRouter = Routers.authRouter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return MaterialApp.router(
          theme: AppThemes.getAppTheme(state.themeType).data,
          locale: LangExtensions.langLocale[state.appLang],
          supportedLocales: LangExtensions.supportedLang,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return BlocListener<AuthCubit, AuthState>(
              listener: (_, state) {
                switch (state) {
                  case AuthStateAuthenticated _:
                    goRouter.go('/home');
                  case AuthStateUnauthenticated _:
                    goRouter.go('/login');
                  case AuthStateUnknown _:
                }
              },
              child: child,
            );
          },
          routerConfig: goRouter,
        );
      },
    );
  }
}

/*
        //** Use this if you want your app in iOs looks like iOs native app and no use Material
        // take into account that some widgets needs to be changes i.e: CupertinoSliverNavigationBar
        // usually to use cupertino widget just add the prefix Cupertino to the widget.
        **//
        getIt<AppPlatform>().isIOS
            ? CupertinoApp.router(
                theme: state.appTheme?.cupertinoThemeData ??
                    Themes.light.getLocalTheme().cupertinoThemeData,
                locale: appLang,
                supportedLocales: LangExtensions.supportedLang,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: AuthState.loggedIn == state.authState
                    ? Routers.mainRouter
                    : Routers.onBoardingRouter(state.authState),
              )
            : */
