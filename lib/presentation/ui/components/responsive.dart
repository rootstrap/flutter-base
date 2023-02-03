import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 500;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width > 500;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  static T mapScreenType<T>(BuildContext context, T Function(ScreenType) onScreen) {
    if (isMobile(context)) {
      return onScreen(ScreenType.mobile);
    }
    if (isTablet(context)) {
      return onScreen(ScreenType.tablet);
    }
    return onScreen(ScreenType.desktop);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 500) {
      return tablet ?? desktop;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}

enum ScreenType { mobile, tablet, desktop }
