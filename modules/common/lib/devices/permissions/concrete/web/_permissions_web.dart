import 'package:common/devices/permissions/abstract/permission_manager.dart';
import 'package:universal_html/html.dart' as html;

class AppPermissions extends PermissionManager {
  @override
  Future<AppPermissionStatus> requestCameraPermission() async {
    final permission =
        await html.window.navigator.permissions?.query({"name": "camera"});
    if (_permissionStatus(permission) != AppPermissionStatus.GRANTED) {
      await html.window.navigator.getUserMedia(video: true);
      final check = await html.window.navigator.permissions
          ?.query({"request": "", "name": "camera"});
      return _permissionStatus(check);
    }
    return AppPermissionStatus.GRANTED;
  }

  @override
  Future<AppPermissionStatus> requestGalleryPermission() async {
    return AppPermissionStatus.GRANTED;
  }

  @override
  Future<AppPermissionStatus> requestNotificationPermission() async {
    //TODO...
    return AppPermissionStatus.DENIED;
  }

  AppPermissionStatus _permissionStatus(html.PermissionStatus? permission) {
    return (permission?.state ?? "denied") == "granted"
        ? AppPermissionStatus.GRANTED
        : AppPermissionStatus.DENIED;
  }
}
