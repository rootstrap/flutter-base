import 'package:flutter_base_rootstrap/globals/globals.dart';
import 'package:flutter_base_rootstrap/resources/locale/localize.dart';

class Preferences {
  static const prefLang = 'app_lang';

  Lang? get appLang =>
      LangExtensions.fromValue(globalPreferences.getString(prefLang));

  void saveAppLang(Lang appLang) {
    globalPreferences.setString(prefLang, appLang.value);
  }
}
