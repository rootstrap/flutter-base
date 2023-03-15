import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/themes/resources/app_theme_data.dart';

abstract class LocalTheme {
  final AppThemeData themeData;

  ColorScheme get colors => themeData.colorScheme;

  LocalTheme({required this.themeData});

  CupertinoThemeData get cupertinoThemeData => CupertinoThemeData.raw(
        themeData.brightness,
        themeData.colorScheme.primary,
        themeData.colorScheme.inversePrimary,
        CupertinoTextThemeData(
          textStyle: bodyS,
          actionTextStyle: buttonText,
          tabLabelTextStyle: overLine,
          navTitleTextStyle: titleL,
          navLargeTitleTextStyle: titleXL,
          navActionTextStyle: titleM,
          pickerTextStyle: bodyS,
          dateTimePickerTextStyle: bodyS,
        ),
        themeData.colorScheme.background,
        themeData.colorScheme.secondaryContainer,
      );

  // By using this configuration you should have this output for each material widget:
  // https://flutter.github.io/samples/web/material_3_demo
  ThemeData get data => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: themeData.palette.primary,
        colorScheme: colors,
        brightness: themeData.brightness,
        textTheme: Typography.blackCupertino.copyWith(
          displayLarge: titleXL,
          displayMedium: titleL,
          displaySmall: titleM,
          headlineLarge: titleS,
          headlineMedium: titleXS,
          headlineSmall: titleXSS,
          bodyLarge: body,
          bodyMedium: bodyS,
          bodySmall: caption,
          titleLarge: subtitleL,
          titleMedium: subtitleM,
          titleSmall: subtitleS,
          labelLarge: buttonText,
          labelMedium: inputText,
          labelSmall: overLine,
        ),
      )
      // to customize your widgets
      // add your custom design here
      // i.e: elevatedButton
      /*  .copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: colors.primary,
            backgroundColor: colors.primary.variant50,
            textStyle: buttonText,
            foregroundColor: colors.onPrimary.variant10,
            enableFeedback: true,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(themeData.borderRadius)),
            ),
          ),
        ),
      )*/
      ;

  final primaryFont = 'Roboto Regular';
  final primaryFontBlack = 'Roboto Black';
  final primaryFontMedium = 'Roboto Medium';
  final primaryFontLight = 'Roboto Light';
  final primaryFontHeavy = 'Roboto Heavy';

  final double titleXLFontSize = 28;
  final double titleLFontSize = 24;
  final double titleMFontSize = 20;
  final double titleSFontSize = 16;
  final double titleXSFontSize = 12;
  final double titleXSSFontSize = 8;
  final double buttonFontSize = 16;
  final double bodyFontSize = 12;
  final double bodyMFontSize = 16;
  final double bodyLFontSize = 20;
  final double bodySFontSize = 8;
  final double navBarFontSize = 12;
  final double subtitleLFontSize = 18;
  final double subtitleMFontSize = 16;
  final double subtitleSFontSize = 12;
  final double inputTextFontSize = 12;
  final double labelFontSize = 12;
  final double labelSFontSize = 8;
  final double captionFontSize = 12;

  get titleXLHeight => 32.4 / titleXLFontSize;

  get titleLHeight => 26.4 / titleLFontSize;

  get titleMHeight => 24 / titleMFontSize;

  get titleSHeight => 19.2 / titleSFontSize;

  get titleXSHeight => 16.8 / titleXSFontSize;

  get buttonHeight => 19.6 / buttonFontSize;

  get bodyHeight => 16.41 / bodyFontSize;

  get bodySHeight => 14 / bodyFontSize;

  get subtitleMHeight => 16.41 / subtitleMFontSize;

  get subtitleSHeight => 12.89 / subtitleSFontSize;

  get inputTextHeight => 13 / inputTextFontSize;

  get labelHeight => 9 / labelFontSize;

  get inputFieldLabelHeight => 7 / labelFontSize;

  get captionHeight => 14 / captionFontSize;

  get titleXL => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: titleXLFontSize,
        height: titleXLHeight,
        letterSpacing: -0.07,
        color: colors.primary,
      );

  get titleL => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: titleLFontSize,
        height: titleLHeight,
        letterSpacing: -0.22,
      );

  get titleM => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: titleMFontSize,
        height: titleMHeight,
        letterSpacing: -0.2,
      );

  get titleS => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: titleSFontSize,
        height: titleSHeight,
        letterSpacing: -0.16,
      );

  get titleXS => TextStyle(
        fontFamily: primaryFontHeavy,
        fontSize: titleXSFontSize,
        height: titleXSHeight,
        letterSpacing: -0.14,
      );

  get titleXSS => TextStyle(
        fontFamily: primaryFontHeavy,
        fontSize: titleXSSFontSize,
        height: titleXSHeight,
        letterSpacing: -0.14,
      );

  get subtitleL => TextStyle(
        fontFamily: primaryFontMedium,
        fontSize: subtitleLFontSize,
        height: subtitleMHeight,
        letterSpacing: 1.2,
      );

  get subtitleM => TextStyle(
        fontFamily: primaryFontMedium,
        fontSize: subtitleMFontSize,
        height: subtitleMHeight,
        letterSpacing: 1.2,
      );

  get subtitleS => TextStyle(
        fontFamily: primaryFontMedium,
        fontSize: subtitleSFontSize,
        height: subtitleSHeight,
        letterSpacing: 1.65,
      );

  get buttonText => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: buttonFontSize,
        height: buttonHeight,
        letterSpacing: 1.4,
      );

  get body => TextStyle(
        fontFamily: primaryFontLight,
        fontSize: bodyFontSize,
        height: bodyHeight,
        fontWeight: FontWeight.normal,
        letterSpacing: -0.14,
      );

  TextStyle get bodyS => TextStyle(
        fontFamily: primaryFontMedium,
        fontSize: bodySFontSize,
        height: bodySHeight,
        fontWeight: FontWeight.normal,
        letterSpacing: -0.14,
      );

  get inputText => TextStyle(
        fontFamily: primaryFontMedium,
        fontSize: titleXSFontSize,
        height: inputTextHeight,
        letterSpacing: 0.1,
      );

  get overLine => TextStyle(
        fontFamily: primaryFontLight,
        fontSize: titleXSFontSize,
        height: inputTextHeight,
        letterSpacing: 0.1,
      );

  get caption => TextStyle(
        fontFamily: primaryFontHeavy,
        fontSize: captionFontSize,
        height: captionHeight,
      );

  get label => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: labelFontSize,
        height: labelHeight,
        letterSpacing: 1,
      );

  get labelS => TextStyle(
        fontFamily: primaryFontBlack,
        fontSize: labelSFontSize,
        height: labelHeight,
        letterSpacing: 1,
      );
}

extension ColorShadow on Color {
  Color variant(int variant) {
    try {
      return (this as MaterialColor)[variant] ?? this;
    } catch (e) {
      return this;
    }
  }

  Color get variant0 => variant(0);

  Color get variant10 => variant(10);

  Color get variant20 => variant(20);

  Color get variant30 => variant(30);

  Color get variant40 => variant(40);

  Color get variant50 => variant(50);

  Color get variant60 => variant(60);

  Color get variant70 => variant(70);

  Color get variant80 => variant(80);

  Color get variant90 => variant(90);

  Color get variant95 => variant(95);

  Color get variant99 => variant(99);

  Color get variant100 => variant(100);
}
