import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presenter/resources/locale/generated/l10n.dart';
import 'package:flutter_base_rootstrap/presenter/resources/locale/lang.dart';
import 'package:flutter_base_rootstrap/presenter/themes/variants/light_theme.dart';
import 'package:flutter_base_rootstrap/presenter/ui/components/cookies.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/skeleton/presentation/pages/skeleton/skeleton_page.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Preferences get _pref => getIt<Preferences>();

  Locale get appLang => LangExtensions.langLocale[_pref.appLang]!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LightTheme().data,
      locale: appLang,
      supportedLocales: LangExtensions.supportedLang,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const Cookies(
              child: SkeletonPage(),
              // child: ServerStatusPage(),
            ),
      },
    );
  }
}
