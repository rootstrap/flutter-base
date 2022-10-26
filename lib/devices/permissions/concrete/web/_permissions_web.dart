import 'package:flutter_base_rootstrap/devices/permissions/abstract/permission_manager.dart';
import 'package:universal_html/html.dart' as html;

class PermissionsWeb extends PermissionManager {
  @override
  Future<AppPermissionStatus> requestCameraPermission() async {
    final permission =
        await html.window.navigator.permissions?.query({"name": "camera"});
    return _permissionStatus(permission);
  }

  @override
  Future<AppPermissionStatus> requestGalleryPermission() async {
    return AppPermissionStatus.GRANTED;
  }

  @override
  Future<AppPermissionStatus> requestNotificationPermission() async {
    var permission =
        await html.window.navigator.permissions?.query({"name": "push"});
    return _permissionStatus(permission);
  }

  AppPermissionStatus _permissionStatus(html.PermissionStatus? permission) {
    return (permission?.state ?? "denied") == "granted"
        ? AppPermissionStatus.GRANTED
        : AppPermissionStatus.DENIED;
  }
}
