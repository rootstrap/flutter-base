import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/global_state/app_global_state.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/global_state/app_global_state_bloc.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/generated/l10n.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/presentation/routers.dart';
import 'package:flutter_base_rootstrap/presentation/themes/app_themes.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Preferences get _pref => getIt<Preferences>();

  Locale get appLang => LangExtensions.langLocale[_pref.appLang]!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppGlobalStateBloc(),
      child: BlocBuilder<AppGlobalStateBloc, AppGlobalState>(
        builder: (context, state) => /*
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
            : */MaterialApp.router(
                theme: state.appTheme?.data ?? AppThemes.light.data,
                locale: state.locale ?? appLang,
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
              ),
      ),
    );
  }
}
