import 'package:flutter_base_rootstrap/presenter/resources/locale/localize.dart';

abstract class Preferences {
  Lang get appLang;

  set appLang(Lang appLang);
}
