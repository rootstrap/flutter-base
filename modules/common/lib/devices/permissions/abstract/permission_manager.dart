abstract class PermissionManager {
  Future<AppPermissionStatus> requestCameraPermission();

  Future<AppPermissionStatus> requestGalleryPermission();

  Future<AppPermissionStatus> requestNotificationPermission();
}

enum AppPermissionStatus {
  GRANTED,
  DENIED,

  /// iOs
  RESTRICTED,

  /// Android/iOS
  DENIED_PERMANTLY,

  /// i.e when location permission is granted only when the app is in use
  LIMITED
}
