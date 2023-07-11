import 'package:flutter/material.dart';
import 'package:domain/models/theme_type.dart';
import 'package:app/presentation/themes/local_theme.dart';
import 'package:app/presentation/themes/resources/app_theme_data.dart';
import 'package:app/presentation/themes/resources/dark_theme_colors.dart';
import 'package:app/presentation/themes/resources/light_theme_colors.dart';

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
