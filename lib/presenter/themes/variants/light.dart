import 'package:flutter_base_rootstrap/presenter/themes/resources/colors_dark.dart';
import 'package:flutter_base_rootstrap/presenter/themes/resources/colors_light.dart';
import 'package:flutter_base_rootstrap/presenter/themes/theme.dart';

class LightTheme extends LocalTheme {
  LightTheme() : super(colors: ColorsLight());
}

class DarkTheme extends LocalTheme {
  DarkTheme() : super(colors: ColorsDark());
}
