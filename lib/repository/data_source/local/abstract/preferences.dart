import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/concrete/preferences.dart';

abstract class Preferences {
  //TODO: temp example until having a dependency injection library
  static final instance = PreferencesImpl();

  Lang get appLang;

  set appLang(Lang appLang);
}
