import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';

abstract class AppPlatform {
  get isWeb => false;

  get isMacOS => false;

  get isFuchsia => false;

  get isLinux => false;

  get isWindows => false;

  get isIOS => false;

  get isAndroid => false;

  PlatformType get currentPlatform {
    if (isWeb) return PlatformType.Web;
    if (isIOS) return PlatformType.iOS;
    if (isAndroid) return PlatformType.Android;
    if (isMacOS) return PlatformType.MacOS;
    if (isFuchsia) return PlatformType.Fuchsia;
    if (isLinux) return PlatformType.Linux;
    if (isWindows) return PlatformType.Windows;
    return PlatformType.Unknown;
  }
}
