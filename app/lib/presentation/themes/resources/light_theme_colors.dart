import 'package:app/presentation/themes/resources/app_theme_data.dart';
import 'package:flutter/material.dart';

class LightThemeColors implements ThemeColors {
  /// 10: onPrimaryContainer
  /// 40: primary
  /// 90: primaryContainer
  /// 100: onPrimary
  @override
  // TODO: implement primary
  MaterialColor get primary => const MaterialColor(40, {
        0: Color(0xFF000000),
        10: Color(0xFF21005D), // Default Bottom navigation bar labels
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D),
        40: Color(0xFF6750A4), // Default Primary Buttons background
        50: Color(0xFFF0524D),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFEADDFF), // Default Bottom navigation bar background or variant button
        95: Color(0xFFF0524D),
        99: Color(0xFFEADDFF),
        100: Color(0xFFFFFFFF),
      });

  /// 10: onSecondaryContainer
  /// 40: secondary
  /// 90: secondaryContainer
  /// 100: onSecondary
  @override
  // TODO: implement secondary
  MaterialColor get secondary => const MaterialColor(40, {
        0: Color(0xFF000000),
        10: Color(0xFF1D192B),
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D),
        40: Color(0xFF625B71),
        50: Color(0xFFF0524D),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFE8DEF8), // Default Bottom navigation labels color
        95: Color(0xFFF0524D),
        99: Color(0xFFE8DEF8),
        100: Color(0xFFFFFFFF),
      });

  /// 10: onTertiaryContainer
  /// 40: tertiary
  /// 90: tertiaryContainer
  /// 100: onTertiary
  @override
  // TODO: implement tertiary
  MaterialColor get tertiary => const MaterialColor(40, {
        0: Color(0xFF000000),
        10: Color(0xFF31111D),
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D),
        40: Color(0xFF7D5260),
        50: Color(0xFFF0524D),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFFFD8E4),
        95: Color(0xFFF0524D),
        99: Color(0xFFF0524D),
        100: Color(0xFFFFFFFF),
      });

  /// 10: onErrorContainer
  /// 40: error
  /// 90: errorContainer
  /// 100: onError
  @override
  // TODO: implement error
  MaterialColor get error => const MaterialColor(40, {
        0: Color(0xFF000000),
        10: Color(0xFF410E0B),
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D),
        40: Color(0xFFB3261E), // Default Error text color & border color
        50: Color(0xFFF0524D),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFF9DEDC),
        95: Color(0xFFF0524D),
        99: Color(0xFFFFD8E4),
        100: Color(0xFFFFFFFF),
      });

  /// 0: shadow
  /// 10: onBackground / onSurface
  /// 99: background / surface
  @override
  // TODO: implement neutral
  MaterialColor get neutral => const MaterialColor(40, {
        0: Color(0xFFFFFFFF), // Default Shadow
        10: Color(0xFFFFFFFF), // Default Text color
        20: Color(0xFFFFFFFF),
        30: Color(0xFFFFFFFF),
        40: Color(0xFFFFFFFF),
        50: Color(0xFFFFFFFF),
        60: Color(0xFFFFFFFF),
        70: Color(0xFFFFFFFF),
        80: Color(0xFFFFFFFF),
        90: Color(0xFFFFFFFF),
        95: Color(0xFFFFFFFF),
        99: Color(0xFFFFFFFF), // Default scaffold background
        100: Color(0xFFFFFFFF),
      });

  /// 30: onSurfaceVariant
  /// 50: outline
  /// 80: outlineVariant
  /// 90: surfaceVariant
  @override
  // TODO: implement neutralVariant
  MaterialColor get neutralVariant => const MaterialColor(40, {
        0: Color(0xFF000000),
        10: Color(0xFF49454F),
        20: Color(0xFFF0524D),
        30: Color(0xFFF0524D), // Labels in TextFormFields
        40: Color(0xFFF0524D),
        50: Color(0xFFFFFFFF),
        60: Color(0xFFF0524D),
        70: Color(0xFFF0524D),
        80: Color(0xFFF0524D),
        90: Color(0xFFF0524D),
        95: Color(0xFFF0524D),
        99: Color(0xFFE7E0EC),
        100: Color(0xFFF0524D),
      });
}
