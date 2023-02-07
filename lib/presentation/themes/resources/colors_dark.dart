import 'dart:ui';

import 'package:flutter_base_rootstrap/presentation/themes/resources/colors.dart';

/// Change the colors for the dark theme
class ColorsDark implements AppColors {
  @override
  Color get background => const Color(0xFF222222);

  @override
  Color get dividerColor => const Color(0xFFFEFEFE);

  @override
  Color get error => const Color(0xFFF0524D);

  @override
  Color get onBackground => const Color(0xFFFEFEFE);

  @override
  Color get onPrimary => const Color(0xFF000000);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get onSurface => const Color(0xFFFFFFFF);

  @override
  Color get primary => const Color(0xFFFFFFFF);

  @override
  Color get secondary => const Color(0xFFF0C738);

  @override
  Color get shadowColor => const Color(0xFF777777);

  @override
  Color get success => const Color(0xFFF0C738);

  @override
  Color get surface => const Color(0xFF222222);

  @override
  Color get warning => const Color(0xFFF0C738);

  @override
  Color get onError => const Color(0xFFFFFFFF);
}
