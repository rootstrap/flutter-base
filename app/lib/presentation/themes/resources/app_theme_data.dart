import 'package:flutter/material.dart';

class AppThemeData {
  // Use to define if is dark or light theme
  // Brightness.dark //Brightness.light
  final Brightness brightness;
  final ThemeColors palette;
  final double borderRadius;
  final ColorScheme? customColorScheme;

  AppThemeData(this.brightness, this.palette, this.borderRadius, this.customColorScheme);

  ColorScheme get colorScheme => customColorScheme ?? ColorScheme(
        brightness: brightness,
        primary: palette.primary[40]!,
        onPrimary: palette.primary[100]!,
        primaryContainer: palette.primary[90]!,
        onPrimaryContainer: palette.primary[10]!,
        secondary: palette.secondary[40]!,
        onSecondary: palette.secondary[100]!,
        secondaryContainer: palette.secondary[90]!,
        onSecondaryContainer: palette.secondary[10]!,
        tertiary: palette.tertiary[40]!,
        onTertiary: palette.tertiary[100]!,
        tertiaryContainer: palette.tertiary[90]!,
        onTertiaryContainer: palette.tertiary[10]!,
        error: palette.error[40]!,
        onError: palette.error[100]!,
        errorContainer: palette.error[90]!,
        onErrorContainer: palette.error[10]!,
        background: palette.neutral[99]!,
        onBackground: palette.neutral[10]!,
        surface: palette.neutral[99]!,
        onSurface: palette.neutral[10]!,
        surfaceVariant: palette.neutralVariant[90]!,
        onSurfaceVariant: palette.neutralVariant[30]!,
        outline: palette.neutralVariant[50]!,
        outlineVariant: palette.neutralVariant[80]!,
        shadow: palette.neutral[0]!,
        scrim: palette.neutral[0]!,
        inverseSurface: palette.neutral[20]!,
        inversePrimary: palette.primary[80]!,
      );
}

/**
 * To define material colors:
 * First argument is the primary color of the pallete
 *  const MaterialColor(40, {
    0: Color(0xFF000000),
    10: Color(0xFFF0524D),
    20: Color(0xFFF0524D),
    30: Color(0xFFF0524D),
    40: Color(0xFFF0524D),
    50: Color(0xFFF0524D),
    60: Color(0xFFF0524D),
    70: Color(0xFFF0524D),
    80: Color(0xFFF0524D),
    90: Color(0xFFF0524D),
    95: Color(0xFFF0524D),
    99: Color(0xFFF0524D),
    100: Color(0xFFF0524D),
    });

 * **/
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
