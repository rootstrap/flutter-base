import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';

class PreferencesImpl extends Preferences {
  final String _prefLang = 'app_lang';

  @override
  Lang get appLang => LangExtensions.fromValue(
        globalPreferences.getString(_prefLang),
      );

  @override
  set appLang(Lang appLang) => globalPreferences.setString(
        _prefLang,
        appLang.value,
      );
}
