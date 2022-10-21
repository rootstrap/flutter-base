import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';

abstract class AppPlatform {
  get isWeb => false;

  get isMacOS => false;

  get isFuchsia => false;

  get isLinux => false;

  get isWindows => false;

  get isIOS => false;

  get isAndroid => false;

  PlatformType get currentPlatform => isWeb
      ? PlatformType.Web
      : isMacOS
          ? PlatformType.MacOS
          : isFuchsia
              ? PlatformType.Fuchsia
              : isLinux
                  ? PlatformType.Linux
                  : isWindows
                      ? PlatformType.Windows
                      : isIOS
                          ? PlatformType.iOS
                          : isAndroid
                              ? PlatformType.Android
                              : PlatformType.Unknown;
}
