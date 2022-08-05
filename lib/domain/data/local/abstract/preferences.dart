import 'package:flutter_base_rootstrap/domain/data/local/concrete/preferences.dart';
import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';

abstract class Preferences {
  //TODO: temp example until having a dependency injection library
  static final instance = PreferencesImpl();

  Lang get appLang;

  set appLang(Lang appLang);
}
