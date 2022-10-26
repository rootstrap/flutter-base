import 'package:flutter_base_rootstrap/devices/permissions/abstract/permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManagerBase extends PermissionManager {
  @override
  Future<AppPermissionStatus> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.toAppPermission();
  }

  @override
  Future<AppPermissionStatus> requestGalleryPermission() async {
    var status = await Permission.photos.request();
    return status.toAppPermission();
  }

  @override
  Future<AppPermissionStatus> requestNotificationPermission() async {
    var status = await Permission.notification.request();
    return status.toAppPermission();
  }
}

extension FromStatus on PermissionStatus {
  static const Map<PermissionStatus, AppPermissionStatus> _permissionStatus = {
    PermissionStatus.granted: AppPermissionStatus.GRANTED,
    PermissionStatus.denied: AppPermissionStatus.DENIED,
    PermissionStatus.restricted: AppPermissionStatus.RESTRICTED,
    PermissionStatus.permanentlyDenied: AppPermissionStatus.DENIED_PERMANTLY,
    PermissionStatus.limited: AppPermissionStatus.LIMITED,
  };

  AppPermissionStatus toAppPermission() =>
      _permissionStatus[this] ?? AppPermissionStatus.DENIED;
}
