import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/data/data_sources/local/concrete/preferences.dart';
import 'package:flutter_base_rootstrap/data/data_sources/remote/abstract/skeleton_data_source.dart';
import 'package:flutter_base_rootstrap/data/data_sources/remote/concrete/skeleton_data_source_impl.dart';
import 'package:flutter_base_rootstrap/data/repositories/skeleton_repository_impl.dart';
import 'package:flutter_base_rootstrap/devices/permissions/abstract/permission_manager.dart';
import 'package:flutter_base_rootstrap/devices/permissions/concrete/mobile/_permissions_android.dart';
import 'package:flutter_base_rootstrap/devices/permissions/concrete/mobile/_permissions_ios.dart';
import 'package:flutter_base_rootstrap/devices/permissions/concrete/web/_permissions_web.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/app_platform.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';
import 'package:flutter_base_rootstrap/devices/platform/concrete/_app_platform_impl.dart'
    if (dart.library.io) 'package:flutter_base_rootstrap/devices/platform/concrete/mobile_desk/_app_platform_impl.dart'
    if (dart.library.html) 'package:flutter_base_rootstrap/devices/platform/concrete/web/_app_platform_impl.dart';
import 'package:flutter_base_rootstrap/devices/platform/concrete/_platform_info_impl.dart';
import 'package:flutter_base_rootstrap/domain/repositories/skeleton_repository.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/skeleton/skeleton_cubit.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

//**
// GetIt:
// registerFactory: instance will be created on each call
// registerSingleton: a singleton instance will be created when init the app
// registerLazySingleton: a singleton instance will be created the first time is called
// *Async: for async constructors or executing a flow before creating the instance
// to get the instance:
// getIt<ServiceExample>()
// tip: on widgets you should only get services.
// **//
Future<void> initialize() async {
  final pref = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(pref);
  getIt.registerSingleton<Preferences>(PreferencesImpl(getIt()));
  getIt.registerSingleton<AppPlatform>(AppPlatformImpl());
  getIt.registerLazySingleton<PlatformInfo>(() => PlatformInfoImpl(getIt()));
  getIt.registerLazySingleton<PermissionManager>(() {
    final platforms = getIt<AppPlatform>();
    if (platforms.isWeb) {
      return PermissionsWeb();
    }
    if (platforms.isAndroid) {
      return PermissionsAndroid();
    }

    return PermissionsIOs();
  });

  //Data Sources
  getIt.registerLazySingleton<SkeletonDataSource>(
    () => SkeletonDataSourceImpl(),
  );

  //Repositories
  getIt.registerLazySingleton<SkeletonRepository>(
    () => SkeletonRepositoryImpl(getIt()),
  );

  //Cubits
  getIt.registerFactory(() => SkeletonCubit(getIt()));
}
