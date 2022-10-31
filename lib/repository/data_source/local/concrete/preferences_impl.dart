import 'dart:convert';

import 'package:flutter_base_rootstrap/presenter/resources/locale/lang.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesImpl extends Preferences {
  final String _prefLang = 'app_lang';
  final String _apiHeaders = 'api_headers';

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
}
