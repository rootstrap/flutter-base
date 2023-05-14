import 'package:flutter_base_rootstrap/domain/models/app_lang.dart';
import 'package:flutter_base_rootstrap/domain/models/theme_type.dart';

abstract class CommonRepository {
  AppLang getAppLang();

  ThemeType getTheme();

  void setAppLang(AppLang lang);

  void setTheme(ThemeType themeStatus);
}
