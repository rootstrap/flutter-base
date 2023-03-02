import 'package:flutter_base_rootstrap/presentation/bloc/global_state/app_global_state.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/presentation/themes/variants/light.dart';

abstract class Preferences {
  Lang get appLang;

  AuthState get authState;

  bool get cookiesAllowed;

  Themes get appTheme;

  set appLang(Lang appLang);

  set appTheme(Themes theme);

  set authState(AuthState appLang);

  set cookiesAllowed(bool cookiesAllowed);

  set secureHeaders(Map<String, String> headers);

  Map<String, String> get secureHeaders;
}
