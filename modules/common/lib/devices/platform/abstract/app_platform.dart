import 'package:common/devices/platform/abstract/platform_info.dart';

abstract class AppPlatform {
  get isWeb => false;

  get isMacOS => false;

  get isFuchsia => false;

  get isLinux => false;

  get isWindows => false;

  get isIOS => false;

  get isAndroid => false;

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
