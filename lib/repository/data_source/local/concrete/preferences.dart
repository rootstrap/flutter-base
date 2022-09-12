import 'dart:convert';

import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';

class PreferencesImpl extends Preferences {
  final String _prefLang = 'app_lang';
  final String _apiHeaders = 'api_headers';

  @override
  Lang get appLang => LangExtensions.fromValue(
        globalPreferences.getString(_prefLang),
      );

  @override
  set appLang(Lang appLang) => globalPreferences.setString(
        _prefLang,
        appLang.value,
      );

  @override
  set secureHeaders(Map<String, String> headers) {
    if (headers.isNotEmpty) {
      globalPreferences.setString(
        _apiHeaders,
        jsonEncode(headers),
      );
    }
  }

  @override
  Map<String, String> get secureHeaders {
    final headers = globalPreferences.getString(_apiHeaders);

    if (headers != null) {
      return jsonDecode(headers);
    }
    return {};
  }
}
