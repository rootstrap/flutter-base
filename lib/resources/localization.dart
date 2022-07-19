import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/globals/preferences.dart';
import 'package:flutter_base_rootstrap/resources/locale/localize.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  late Map<Localize, String> _localizedStrings;

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  AppLocalizations load() {
    final lang = LangExtensions.fromLocale(locale);
    Localization().currentLang = lang;
    _localizedStrings = localize[lang]!;
    return this;
  }

  String getString(Localize locale, List<String>? params) {
    return _parse(_localizedStrings[locale] ?? '', params: params);
  }

  String _parse(String text, {required List<String>? params}) {
    var localText = text;

    if (params != null) {
      for (int i = 0; i < params.length; i++) {
        localText = localText.replaceAll('%${i + 1}s', params[i]);
      }
    }

    return localText;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var appLang = Preferences().appLang;
    var currentLocale = LangExtensions.langLocale[appLang] ??
        (isSupported(locale) ? locale : LangExtensions.defaultLocaleLang);
    return AppLocalizations(currentLocale).load();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
