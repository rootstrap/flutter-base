import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesImpl extends Preferences {
  final String _prefLang = 'app_lang';

  final SharedPreferences _pref;

  PreferencesImpl(this._pref);

  @override
  Lang get appLang => LangExtensions.fromValue(_pref.getString(_prefLang));

  @override
  set appLang(Lang appLang) => _pref.setString(_prefLang, appLang.value);
}
