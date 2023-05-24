abstract class Preferences {
  bool getCookiesAllowed();

  String? getAppLang();

  String? getAppTheme();

  String? getToken();

  Future<void> setCookiesAllowed(bool cookiesAllowed);

  Future<void> setAppLang(String appLang);

  Future<void> setAppTheme(String theme);

  Future<void> setToken(String? token);
}
