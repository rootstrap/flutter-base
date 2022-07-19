import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/resources/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'en.dart' as enLang;
import 'es.dart' as esLang;

enum Lang { es, en }

enum Localize {
  appName,
}

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
    AppLocalizations.delegate,
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

  static Lang? fromValue(String? fromValue) => langValues[fromValue];

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

const Map<Lang, Map<Localize, String>> localize = {
  Lang.en: enLang.localization,
  Lang.es: esLang.localization,
};
