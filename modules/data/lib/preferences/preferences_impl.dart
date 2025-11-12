import 'package:data/preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesImpl extends Preferences {
  final String _appLangKey = 'appLang';
  final String _tokenKey = 'tokenKey';
  final String _appThemeKey = 'appTheme';
  final String _cookiesAllowedKey = 'cookiesAllowed';

  final SharedPreferences _pref;

  PreferencesImpl(this._pref);

  @override
  String? getAppLang() => _pref.getString(_appLangKey);

  @override
  String? getAppTheme() => _pref.getString(_appThemeKey);

  @override
  bool getCookiesAllowed() => _pref.getBool(_cookiesAllowedKey) ?? false;

  @override
  String? getToken() => _pref.getString(_tokenKey);

  @override
  Future<void> setAppLang(String appLang) {
    return _pref.setString(_appLangKey, appLang);
  }

  @override
  Future<void> setAppTheme(String theme) {
    return _pref.setString(_appThemeKey, theme);
  }

  @override
  Future<void> setCookiesAllowed(bool cookiesAllowed) {
    return _pref.setBool(_cookiesAllowedKey, cookiesAllowed);
  }

  @override
  Future<void> setToken(String? token) {
    if (token == null) return _pref.remove(_tokenKey);
    return _pref.setString(_tokenKey, token);
  }

  @override
  Future<void> clear() {
    return _pref.clear();
  }
}
