import 'package:flutter_base_rootstrap/data/preferences/preferences.dart';
import 'package:flutter_base_rootstrap/domain/models/app_lang.dart';
import 'package:flutter_base_rootstrap/domain/models/theme_type.dart';
import 'package:flutter_base_rootstrap/domain/repositories/common_repository.dart';

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
}
