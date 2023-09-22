import 'package:app/presentation/themes/local_theme.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  // Use to define if is dark or light theme
  // Brightness.dark //Brightness.light
  final Brightness brightness;
  final ThemeColors palette;
  final double borderRadius;

  AppThemeData(this.brightness, this.palette, this.borderRadius);

  ColorScheme get colorScheme => ColorScheme(
        brightness: brightness,
        primary: palette.primary.v40,
        secondary: palette.secondary.v40,
        error: palette.error.v40,
        tertiary: palette.tertiary.v40,
        onPrimary: palette.primary.v100,
        primaryContainer: palette.primary.v90,
        onPrimaryContainer: palette.primary.v10,
        onSecondary: palette.secondary.v100,
        secondaryContainer: palette.secondary.v90,
        onSecondaryContainer: palette.secondary.v10,
        onTertiary: palette.tertiary.v100,
        tertiaryContainer: palette.tertiary.v90,
        onTertiaryContainer: palette.tertiary.v10,
        onError: palette.error.v100,
        errorContainer: palette.error.v90,
        onErrorContainer: palette.error.v10,
        background: palette.neutral.v99,
        onBackground: palette.neutral.v10,
        surface: palette.neutral.v99,
        onSurface: palette.neutral.v10,
        surfaceVariant: palette.neutralVariant.v90,
        onSurfaceVariant: palette.neutralVariant.v30,
        outline: palette.neutralVariant.v50,
        outlineVariant: palette.neutralVariant.v80,
        shadow: palette.neutral.v0,
        scrim: palette.neutral.v0,
        inverseSurface: palette.neutral.v20,
        inversePrimary: palette.primary.v80,
      );
}

abstract class ThemeColors {
  /**
   * 40: primary
   * 100: onPrimary
   * 90: primaryContainer
   * 10: onPrimaryContainer
   * **/
  abstract final MaterialColor primary;

  /**
   * 40: secondary
   * 100: onSecondary
   * 90: secondaryContainer
   * 10: onSecondaryContainer
   * **/
  abstract final MaterialColor secondary;

  /**
   * 40: tertiary
   * 100: onTertiary
   * 90: tertiaryContainer
   * 10: onTertiaryContainer
   * **/
  abstract final MaterialColor tertiary;

  /**
   * 40: error
   * 100: onError
   * 90: errorContainer
   * 10: onErrorContainer
   * **/
  abstract final MaterialColor error;

  /**
   * 0: shadow
   * 99: background / surface
   * 10: onBackground / onSurface
   * **/
  abstract final MaterialColor neutral;

  /**
   * 90: surfaceVariant
   * 30: onSurfaceVariant
   * 50: outline
   * 80: outlineVariant
   * **/
  abstract final MaterialColor neutralVariant;
}
