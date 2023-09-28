import 'package:data/preferences/preferences.dart';
import 'package:domain/models/app_lang.dart';
import 'package:domain/models/theme_type.dart';
import 'package:domain/repositories/common_repository.dart';

class CommonRepositoryImpl implements CommonRepository {
  final Preferences _preferences;

  CommonRepositoryImpl(this._preferences);

  @override
  AppLang getAppLang() {
    final appLangStr = _preferences.getAppLang();
    if (appLangStr == null) return AppLang.en;
    return AppLang.fromName(appLangStr);
  }

  @override
  void setAppLang(AppLang lang) {
    _preferences.setAppLang(lang.name);
  }

  @override
  ThemeType getTheme() {
    final themeStatusStr = _preferences.getAppTheme();
    if (themeStatusStr == null) return ThemeType.light;
    return ThemeType.fromName(themeStatusStr);
  }

  @override
  void setTheme(ThemeType themeType) {
    _preferences.setAppTheme(themeType.name);
  }

  @override
  bool areCookiesAllowed() {
    return _preferences.getCookiesAllowed();
  }

  @override
  void setAcceptCookies(bool isAllowed) {
    _preferences.setCookiesAllowed(isAllowed);
  }
}
