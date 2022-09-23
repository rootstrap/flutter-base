import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presenter/resources/locale/generated/l10n.dart';
import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/presenter/themes/variants/light.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'di_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const MyApp());
}

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
        '/': (context) => Scaffold(
              body: Center(
                child: Text(
                  S.of(context).appName,
                ),
              ),
            ),
      },
    );
  }
}
