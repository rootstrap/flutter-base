import 'package:common/devices/platform/abstract/platform_info.dart';

abstract class AppPlatform {
  bool get isWeb => false;

  bool get isMacOS => false;

  bool get isFuchsia => false;

  bool get isLinux => false;

  bool get isWindows => false;

  bool get isIOS => false;

  bool get isAndroid => false;

  PlatformType get currentPlatform {
    if (isWeb) return PlatformType.web;
    if (isIOS) return PlatformType.iOS;
    if (isAndroid) return PlatformType.android;
    if (isMacOS) return PlatformType.macOS;
    if (isFuchsia) return PlatformType.fuchsia;
    if (isLinux) return PlatformType.linux;
    if (isWindows) return PlatformType.windows;
    return PlatformType.unknown;
  }
}
