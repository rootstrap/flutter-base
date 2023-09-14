import 'package:common/devices/platform/abstract/app_platform.dart';
import 'package:common/devices/platform/abstract/platform_info.dart';
import 'package:common/init.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder small;
  final ResponsiveWidgetBuilder? medium;
  final ResponsiveWidgetBuilder big;

  AppPlatform get _platform => getIt.get();

  const ResponsiveBuilder({
    Key? key,
    required this.small,
    required this.big,
    this.medium,
  }) : super(key: key);

  Orientation _screenOrientation(BuildContext context) =>
      MediaQuery.orientationOf(context);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final platform = _platform.currentPlatform;
    final orientation = _screenOrientation(context);
    ResponsiveWidgetBuilder builder = small;

    if (size.width >= 1100 && !_platform.isIOS && !_platform.isAndroid) {
      builder = big;
    } else if (size.width >= 500) {
      builder = medium ?? big;
    }

    return builder.call(
      context,
      orientation,
      platform,
    );
  }
}

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  Orientation orientation,
  PlatformType platform,
);
