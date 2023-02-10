import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/generated/l10n.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/presentation/themes/variants/light.dart';
import 'package:flutter_base_rootstrap/presentation/ui/components/cookies.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_page.dart';
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
              child: HomePage(),
            ),
      },
    );
  }
}
