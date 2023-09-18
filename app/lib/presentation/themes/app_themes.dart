import 'package:domain/bloc/app/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:domain/models/theme_type.dart';
import 'package:app/presentation/themes/local_theme.dart';
import 'package:app/presentation/themes/resources/app_theme_data.dart';
import 'package:app/presentation/themes/resources/dark_theme_colors.dart';
import 'package:app/presentation/themes/resources/light_theme_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppThemes {
  static LocalTheme get light => LightTheme();

  static LocalTheme get dark => DarkTheme();

  static LocalTheme getAppTheme(ThemeType themeType) {
    return switch (themeType) {
      ThemeType.light => light,
      ThemeType.dark => dark,
    };
  }
}

class LightTheme extends LocalTheme {
  LightTheme()
      : super(
          themeData: AppThemeData(
            Brightness.light,
            LightThemeColors(),
            8.0,
          ),
        );
}

class DarkTheme extends LocalTheme {
  DarkTheme()
      : super(
          themeData: AppThemeData(
            Brightness.dark,
            DarkThemeColors(),
            8.0,
          ),
        );
}

/// For projects where the design is custom and use more colors than the ones definded for Material Design,
/// get access to the colors defined in the theme by using the following extension:
///
/// context.colors.primary
/// context.colors.secondary
/// context.colors.tertiary
/// context.colors.error
/// context.colors.neutral
/// context.colors.neutralVariant
///
/// All their variants (v0, v10, v20, v30, v40, v50, v60, v70, v80, v90, v95, v99, v100)
/// i.e: context.colors.primary.v40
///
/// Check the official documentation to understand where to use each color:
/// https://m3.material.io/styles/color/the-color-system/key-colors-tones#5b4f0cd4-beb7-41b1-b6ff-a952fcbea726
/// https://m3.material.io/styles/color/the-color-system/color-roles
extension AppLocalTheme on BuildContext {
  LocalTheme get localTheme => AppThemes.getAppTheme(
        select<AppCubit, ThemeType>(
          (value) => value.state.themeType,
        ),
      );

  ThemeData get theme => Theme.of(this);

  ThemeColors get colors => localTheme.themeData.palette;
}
