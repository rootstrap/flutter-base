import 'package:flutter_base_rootstrap/domain/data/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/globals/globals.dart';
import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';

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
