import 'package:flutter_base_rootstrap/presentation/themes/resources/colors_dark.dart';
import 'package:flutter_base_rootstrap/presentation/themes/resources/colors_light.dart';
import 'package:flutter_base_rootstrap/presentation/themes/theme.dart';

class LightTheme extends LocalTheme {
  LightTheme() : super(colors: ColorsLight());
}

class DarkTheme extends LocalTheme {
  DarkTheme() : super(colors: ColorsDark());
}

enum Themes { light, dark }

extension ThemeType on Themes {
  static Map<String, Themes> themesValues = {
    Themes.light.toString(): Themes.light,
    Themes.dark.toString(): Themes.dark,
  };

  static Themes getTheme(String? fromValue) =>
      themesValues[fromValue ?? Themes.light.toString()]!;

  LocalTheme getLocalTheme() {
    return this == Themes.light ? LightTheme() : DarkTheme();
  }
}
