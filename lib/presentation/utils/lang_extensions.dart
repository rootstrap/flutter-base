import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/domain/models/app_lang.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
extension LangExtensions on AppLang {
  static const supportedLang = [
    Locale('en', ''), // English, no country code
    Locale('es', ''), // Spanish, no country code
  ];

  static const appLocalizationDelegates = [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Map<AppLang, Locale> langLocale = {
    AppLang.en: const Locale('en', ''),
    AppLang.es: const Locale('es', ''),
  };

  static AppLang defaultLang = AppLang.en;
  static Locale defaultLocaleLang = const Locale('en', '');

  static AppLang fromLocale(Locale locale) {
    var lang = defaultLang;
    langLocale.forEach((key, value) {
      if (value.languageCode == locale.languageCode) {
        lang = key;
      }
    });

    return lang;
  }

  Locale get locale => langLocale[this] ?? defaultLocaleLang;

  String get value => toString();
}
