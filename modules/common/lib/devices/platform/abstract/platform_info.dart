abstract class PlatformInfo {
  bool get isDesktopOS;

  bool get isAppOS;

  bool get isWeb;

  bool get isAndroid;

  bool get isIOS;

  Future<String> get version;

  PlatformType get currentPlatform;

  String get getCurrentPlatformType;
}

enum PlatformType { web, iOS, android, macOS, fuchsia, linux, windows, unknown }

extension PlatformTypeString on PlatformType {
  String get name => toString().split('.').last;
}
