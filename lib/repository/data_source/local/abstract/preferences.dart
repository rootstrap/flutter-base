import 'package:flutter_base_rootstrap/presenter/resources/locale/lang.dart';

abstract class Preferences {
  Lang get appLang;

  bool get cookiesAllowed;

  set appLang(Lang appLang);

  set cookiesAllowed(bool cookiesAllowed);

  set secureHeaders(Map<String, String> headers);

  Map<String, String> get secureHeaders;
}
