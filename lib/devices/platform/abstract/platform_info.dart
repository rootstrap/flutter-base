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

// ignore: constant_identifier_names
enum PlatformType { Web, iOS, Android, MacOS, Fuchsia, Linux, Windows, Unknown }

extension PlatformTypeString on PlatformType {
  String get name => toString().split('.').last;
}
