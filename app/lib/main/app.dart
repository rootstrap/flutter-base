import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/app/app_state.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/models/app_lang.dart';
import 'package:app/presentation/navigation/routers.dart';
import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/themes/app_themes.dart';
import 'package:app/presentation/utils/lang_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:app_links/app_links.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'init.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;
  bool _isRouterReady = false;

  @override
  void initState() {
    super.initState();
    _initRouter();
  }

  Future<void> _initRouter() async {
    String? initialLocation;
    if (kIsWeb) {
      final path = Uri.base.path;
      if (path.isNotEmpty && path != '/') {
        initialLocation = path;
      }
    } else {
      final appLinks = AppLinks();
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        initialLocation = initialUri.path;
      }
    }

    debugPrint('App entry point: $initialLocation');

    if (mounted) {
      setState(() {
        _router = Routes.init(
          context,
          initialLocation: initialLocation,
        );
        _isRouterReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: !_isRouterReady
          ? const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: AppThemes.getAppTheme(state.themeType).data,
                  locale: LangExtensions.langLocale[state.appLang],
                  supportedLocales: LangExtensions.supportedLang,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  builder: (context, child) =>
                      child ??
                      const Material(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  routerConfig: _router,
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
