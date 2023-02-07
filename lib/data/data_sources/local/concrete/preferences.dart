import 'dart:convert';

import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/localize.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesImpl extends Preferences {
  final String _prefLang = 'app_lang';
  final String _apiHeaders = 'api_headers';
  final String _cookiesAllowed = 'cookies_allowed';

  final SharedPreferences _pref;

  PreferencesImpl(this._pref);

  @override
  Lang get appLang => LangExtensions.fromValue(_pref.getString(_prefLang));

  @override
  set appLang(Lang appLang) => _pref.setString(
        _prefLang,
        appLang.value,
      );

  @override
  set secureHeaders(Map<String, String> headers) {
    if (headers.isNotEmpty) {
      _pref.setString(
        _apiHeaders,
        jsonEncode(headers),
      );
    }
  }

  @override
  Map<String, String> get secureHeaders {
    final headers = _pref.getString(_apiHeaders);

    if (headers != null) {
      return jsonDecode(headers);
    }
    return {};
  }

  @override
  bool get cookiesAllowed => _pref.getBool(_cookiesAllowed) ?? false;

  @override
  set cookiesAllowed(bool cookiesAllowed) {
    _pref.setBool(_cookiesAllowed, cookiesAllowed);
  }
}
