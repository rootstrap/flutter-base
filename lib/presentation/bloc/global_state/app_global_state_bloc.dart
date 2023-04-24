import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/global_state/app_global_state.dart';
import 'package:flutter_base_rootstrap/presentation/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/presentation/themes/app_themes.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppGlobalStateBloc extends Cubit<AppGlobalState> {
  Preferences get preferences => getIt();

  AppGlobalStateBloc() : super(AppGlobalState()) {
    _checkOutState();
  }

  void _checkOutState() async {
    emit(
      AppGlobalState(
        authState: preferences.authState,
        appTheme: preferences.appTheme.getLocalTheme(),
        locale: preferences.appLang.locale,
      ),
    );
  }

  void logout() {
    preferences.authState = AuthState.loggedOut;
    _checkOutState();
  }

  void logIn() {
    preferences.authState = AuthState.loggedIn;
    _checkOutState();
  }

  void updateTheme(Themes theme) {
    preferences.appTheme = theme;
    _checkOutState();
  }
}
