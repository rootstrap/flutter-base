import 'package:get_it/get_it.dart';
import 'package:common/devices/permissions/abstract/permission_manager.dart';
import 'package:common/devices/permissions/concrete/mobile/_permissions_android.dart'
    if (dart.library.io) 'package:common/devices/permissions/concrete/mobile/_permissions_android.dart'
    if (dart.library.html) 'package:common/devices/permissions/concrete/web/_permissions_web.dart';
import 'package:common/devices/permissions/concrete/mobile/_permissions_ios.dart';
import 'package:common/devices/platform/abstract/app_platform.dart';
import 'package:common/devices/platform/abstract/platform_info.dart';
import 'package:common/devices/platform/concrete/_app_platform_impl.dart'
    if (dart.library.io) 'package:common/devices/platform/concrete/mobile_desk/_app_platform_impl.dart'
    if (dart.library.html) 'package:common/devices/platform/concrete/web/_app_platform_impl.dart';
import 'package:common/devices/platform/concrete/_platform_info_impl.dart';

class CommonInit {
  static Future<void> initialize(GetIt getIt) async {
    getIt.registerSingleton<AppPlatform>(AppPlatformImpl());
    getIt.registerLazySingleton<PlatformInfo>(() => PlatformInfoImpl(getIt()));
    getIt.registerLazySingleton<PermissionManager>(() {
      final platforms = getIt<AppPlatform>();
      if (platforms.isIOS) {
        return AppPermissionsIOs();
      }

      return AppPermissions();
    });
  }
}
