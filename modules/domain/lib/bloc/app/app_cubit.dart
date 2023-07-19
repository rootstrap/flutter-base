import 'package:domain/bloc/app/app_state.dart';
import 'package:domain/models/app_lang.dart';
import 'package:domain/models/theme_type.dart';
import 'package:domain/repositories/common_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppState> {
  final CommonRepository _commonRepository;

  AppCubit(this._commonRepository)
      : super(AppState(
          themeType: _commonRepository.getTheme(),
          appLang: _commonRepository.getAppLang(),
        ));

  void updateTheme(ThemeType theme) {
    _commonRepository.setTheme(theme);
    emit(state.copyWith(themeType: theme));
  }

  void updateAppLang(AppLang appLang) {
    _commonRepository.setAppLang(appLang);
    emit(state.copyWith(appLang: appLang));
  }
}
