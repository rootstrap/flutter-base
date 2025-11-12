import 'package:app/presentation/themes/resources/app_theme_data.dart';
import 'package:flutter/material.dart';

class LightThemeColors implements ThemeColors {
  /// 10: onPrimaryContainer
  /// 40: primary
  /// 80: inversePrimary
  /// 90: primaryContainer
  /// 100: onPrimary
  @override
  MaterialColor get primary => const MaterialColor(0xFF6750A4, {
        0: Color(0xFF000000),
        10: Color(0xFF21005D), // onPrimaryContainer
        20: Color(0xFF381E72),
        30: Color(0xFF4F378B),
        40: Color(0xFF6750A4), // primary - Main brand color
        50: Color(0xFF7F67BE),
        60: Color(0xFF9A82DB),
        70: Color(0xFFB69DF8),
        80: Color(0xFFD0BCFF), // inversePrimary
        90: Color(0xFFEADDFF), // primaryContainer
        95: Color(0xFFF6EDFF),
        99: Color(0xFFFFFBFE),
        100: Color(0xFFFFFFFF), // onPrimary
      });

  /// 10: onSecondaryContainer
  /// 40: secondary
  /// 90: secondaryContainer
  /// 100: onSecondary
  @override
  MaterialColor get secondary => const MaterialColor(0xFF625B71, {
        0: Color(0xFF000000),
        10: Color(0xFF1D192B), // onSecondaryContainer
        20: Color(0xFF332D41),
        30: Color(0xFF4A4458),
        40: Color(0xFF625B71), // secondary
        50: Color(0xFF7A7289),
        60: Color(0xFF958DA5),
        70: Color(0xFFB0A7C0),
        80: Color(0xFFCCC2DC),
        90: Color(0xFFE8DEF8), // secondaryContainer
        95: Color(0xFFF6EDFF),
        99: Color(0xFFFFFBFE),
        100: Color(0xFFFFFFFF), // onSecondary
      });

  /// 10: onTertiaryContainer
  /// 40: tertiary
  /// 90: tertiaryContainer
  /// 100: onTertiary
  @override
  MaterialColor get tertiary => const MaterialColor(0xFF7D5260, {
        0: Color(0xFF000000),
        10: Color(0xFF31111D), // onTertiaryContainer
        20: Color(0xFF492532),
        30: Color(0xFF633B48),
        40: Color(0xFF7D5260), // tertiary
        50: Color(0xFF986977),
        60: Color(0xFFB58392),
        70: Color(0xFFD29DAC),
        80: Color(0xFFEFB8C8),
        90: Color(0xFFFFD8E4), // tertiaryContainer
        95: Color(0xFFFFECF1),
        99: Color(0xFFFFFBFA),
        100: Color(0xFFFFFFFF), // onTertiary
      });

  /// 10: onErrorContainer
  /// 40: error
  /// 90: errorContainer
  /// 100: onError
  @override
  MaterialColor get error => const MaterialColor(0xFFB3261E, {
        0: Color(0xFF000000),
        10: Color(0xFF410E0B), // onErrorContainer
        20: Color(0xFF601410),
        30: Color(0xFF8C1D18),
        40: Color(0xFFB3261E), // error
        50: Color(0xFFDC362E),
        60: Color(0xFFE46962),
        70: Color(0xFFEC928E),
        80: Color(0xFFF2B8B5),
        90: Color(0xFFF9DEDC), // errorContainer
        95: Color(0xFFFCEEEE),
        99: Color(0xFFFFFBF9),
        100: Color(0xFFFFFFFF), // onError
      });

  /// 0: shadow / scrim
  /// 10: onSurface
  /// 20: inverseSurface
  /// 99: surface
  @override
  MaterialColor get neutral => const MaterialColor(0xFF1C1B1F, {
        0: Color(0xFF000000), // shadow / scrim
        10: Color(0xFF1C1B1F), // onSurface - Main text color
        20: Color(0xFF313033), // inverseSurface
        30: Color(0xFF484649),
        40: Color(0xFF605D62),
        50: Color(0xFF787579),
        60: Color(0xFF939094),
        70: Color(0xFFAEAAAE),
        80: Color(0xFFC9C5CA),
        90: Color(0xFFE6E1E5),
        95: Color(0xFFF4EFF4),
        99: Color(0xFFFFFBFE), // surface - Main background
        100: Color(0xFFFFFFFF),
      });

  /// 30: onSurfaceVariant
  /// 50: outline
  /// 80: outlineVariant
  /// 90: surfaceContainerHighest
  @override
  MaterialColor get neutralVariant => const MaterialColor(0xFF49454F, {
        0: Color(0xFF000000),
        10: Color(0xFF1D1A22),
        20: Color(0xFF322F37),
        30: Color(0xFF49454F), // onSurfaceVariant - Secondary text, icons
        40: Color(0xFF605D66),
        50: Color(0xFF79747E), // outline - Borders, dividers
        60: Color(0xFF938F99),
        70: Color(0xFFAEA9B4),
        80: Color(0xFFC9C5D0), // outlineVariant - Subtle borders
        90: Color(0xFFE7E0EC), // surfaceContainerHighest
        95: Color(0xFFF5EEFA),
        99: Color(0xFFFFFBFE),
        100: Color(0xFFFFFFFF),
      });
}
