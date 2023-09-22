import 'package:flutter/material.dart';
import 'package:app/presentation/themes/resources/app_theme_data.dart';

/// Change the colors for the dark theme
class DarkThemeColors implements ThemeColors {
  /**
   * 40: primary
   * 100: onPrimary
   * 90: primaryContainer
   * 10: onPrimaryContainer
   * **/
  @override
  // TODO: implement primary
  MaterialColor get primary => const MaterialColor(40, {
        0: Color(0xFFFFFFDE),
        10: Color(0xFFFFFFDE),
        20: Color(0xFFFFFFDE),
        30: Color(0xFFFFFFDE),
        40: Color(0xFFFFFFDE),
        50: Color(0xFFFFFFDE),
        60: Color(0xFFFFFFDE),
        70: Color(0xFFFFFFDE),
        80: Color(0xFFFFFFDE),
        90: Color(0xFF6750A4),
        95: Color(0xFFFFFFDE),
        99: Color(0xFF6750A4),
        100: Color(0xFF6750A4),
      });

  /**
   * 40: secondary
   * 100: onSecondary
   * 90: secondaryContainer
   * 10: onSecondaryContainer
   * **/
  @override
  // TODO: implement secondary
  MaterialColor get secondary => const MaterialColor(40, {
        0: Color(0xFFFFFFDE),
        10: Color(0xFF1D192B),
        20: Color(0xFFFFFFDE),
        30: Color(0xFFFFFFDE),
        40: Color(0xFFFFFFFD),
        50: Color(0xFFFFFFDE),
        60: Color(0xFFFFFFDE),
        70: Color(0xFFFFFFDE),
        80: Color(0xFFFFFFDE),
        90: Color(0xFF1D192B),
        95: Color(0xFFFFFFDE),
        99: Color(0xFF1D192B),
        100: Color(0xFF1D192B),
      });

  /**
   * 40: tertiary
   * 100: onTertiary
   * 90: tertiaryContainer
   * 10: onTertiaryContainer
   * **/
  @override
  // TODO: implement tertiary
  MaterialColor get tertiary => const MaterialColor(40, {
        0: Color(0xFFFFFFDE),
        10: Color(0xFFFFFFDE),
        20: Color(0xFFFFFFDE),
        30: Color(0xFFFFFFDE),
        40: Color(0xFFFFFFDE),
        50: Color(0xFFFFFFDE),
        60: Color(0xFFFFFFDE),
        70: Color(0xFFFFFFDE),
        80: Color(0xFFFFFFDE),
        90: Color(0xFFF0524D),
        95: Color(0xFFFFFFDE),
        99: Color(0xFFFFFFDE),
        100: Color(0xFFF0524D),
      });

  /**
   * 40: error
   * 100: onError
   * 90: errorContainer
   * 10: onErrorContainer
   * **/
  @override
  // TODO: implement error
  MaterialColor get error => const MaterialColor(40, {
        0: Color(0xFFFFFFDE),
        10: Color(0xFF410E0B),
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D),
        40: Color(0xFFB3261E),
        50: Color(0xFFF0524D),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFF9DEDC),
        95: Color(0xFFF0524D),
        99: Color(0xFFFFD8E4),
        100: Color(0xFFFFFFFF),
      });

  /**
   * 0: shadow
   * 99: background / surface
   * 10: onBackground / onSurface
   * **/
  @override
  // TODO: implement neutral
  MaterialColor get neutral => const MaterialColor(40, {
        0: Color(0xFF410E0B),
        10: Color(0xFF410E0B),
        20: Color(0xFF410E0B),
        30: Color(0xFF410E0B),
        40: Color(0xFF410E0B),
        50: Color(0xFF410E0B),
        60: Color(0xFF410E0B),
        70: Color(0xFF410E0B),
        80: Color(0xFF410E0B),
        90: Color(0xFF410E0B),
        95: Color(0xFF410E0B),
        99: Color(0xFF410E0B),
        100: Color(0xFF410E0B),
      });

  /**
   * 90: surfaceVariant
   * 30: onSurfaceVariant
   * 50: outline
   * 80: outlineVariant
   * **/
  @override
  // TODO: implement neutralVariant
  MaterialColor get neutralVariant => const MaterialColor(40, {
        0: Color(0xFF000000),
        10: Color(0xFF49454F),
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D),
        40: Color(0xFFFDDDDE),
        50: Color(0xFFF0524D),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFF0524D),
        95: Color(0xFFFDDDDE),
        99: Color(0xFFF0524D),
        100: Color(0xFFF0524D),
      });
}
