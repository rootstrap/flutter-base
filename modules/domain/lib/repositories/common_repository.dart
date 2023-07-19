import 'package:domain/models/app_lang.dart';
import 'package:domain/models/theme_type.dart';

abstract class CommonRepository {
  AppLang getAppLang();

  ThemeType getTheme();

  void setAppLang(AppLang lang);

  void setTheme(ThemeType themeStatus);

  bool areCookiesAllowed();

  void setAcceptCookies(bool isAllowed);
}
