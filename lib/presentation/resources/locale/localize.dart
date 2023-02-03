import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

enum Lang { es, en }

class Localization {
  Lang currentLang = LangExtensions.defaultLang;

  void saveLang(Lang lang) {
    currentLang = lang;
    //TODO: notify lang change
  }
}

extension LangExtensions on Lang {
  static Map<String, Lang> langValues = {
    Lang.en.toString(): Lang.en,
    Lang.es.toString(): Lang.es
  };

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

  static Map<Lang, Locale> langLocale = {
    Lang.en: const Locale('en', ''),
    Lang.es: const Locale('es', '')
  };

  static Lang defaultLang = Lang.en;
  static Locale defaultLocaleLang = const Locale('en', '');

  static Lang fromValue(String? fromValue) =>
      langValues[fromValue ?? defaultLang.value]!;

  static Lang fromLocale(Locale locale) {
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
