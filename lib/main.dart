import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/globals/preferences.dart';
import 'package:flutter_base_rootstrap/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/resources/resources.dart';
import 'package:flutter_base_rootstrap/theme/variants/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Locale get appLang =>
      LangExtensions.langLocale[Preferences().appLang] ??
      LangExtensions.defaultLocaleLang;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LightTheme().data,
      locale: appLang,
      supportedLocales: LangExtensions.supportedLang,
      localizationsDelegates: LangExtensions.appLocalizationDelegates,
      home: Scaffold(
        body: Center(
          child: Text(context.getString(Localize.appName)),
        ),
      ),
    );
  }
}
