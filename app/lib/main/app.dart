import 'package:common/core/resource.dart';
import 'package:flutter/material.dart';
import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/app/app_state.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/auth/auth_state.dart';
import 'package:app/presentation/navigation/routers.dart';
import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/themes/app_themes.dart';
import 'package:app/presentation/utils/lang_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'init.dart';

class App extends StatelessWidget {
  GoRouter get _goRouter => Routers.authRouter;

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppCubit>()),
        BlocProvider(create: (_) => getIt<SessionCubit>()),
      ],
      child: BlocBuilder<AppCubit, AppState>(
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
              return BlocListener<SessionCubit, Resource>(
                listener: (_, state) {
                  if (state is Success<AuthState>) {
                    switch (state.data) {
                      case AuthStateAuthenticated _:
                        _goRouter.go('/home');
                      case AuthStateUnauthenticated _:
                        _goRouter.go('/login');
                      case _:
                    }
                  }
                },
                child: child,
              );
            },
            routerConfig: _goRouter,
          );
        },
      ),
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
