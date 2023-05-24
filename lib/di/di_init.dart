import 'package:dio/dio.dart';
import 'package:flutter_base_rootstrap/data/data_sources/remote/abstract/product_data_source.dart';
import 'package:flutter_base_rootstrap/data/data_sources/remote/concrete/product_data_source_impl.dart';
import 'package:flutter_base_rootstrap/data/network/config/network_config.dart';
import 'package:flutter_base_rootstrap/data/preferences/preferences.dart';
import 'package:flutter_base_rootstrap/data/preferences/preferences_impl.dart';
import 'package:flutter_base_rootstrap/data/repositories/auth_repository_impl.dart';
import 'package:flutter_base_rootstrap/data/repositories/common_repository_impl.dart';
import 'package:flutter_base_rootstrap/data/repositories/product_repository_impl.dart';
import 'package:flutter_base_rootstrap/devices/permissions/abstract/permission_manager.dart';
import 'package:flutter_base_rootstrap/devices/permissions/concrete/mobile/_permissions_android.dart'
    if (dart.library.io) 'package:flutter_base_rootstrap/devices/permissions/concrete/mobile/_permissions_android.dart'
    if (dart.library.html) 'package:flutter_base_rootstrap/devices/permissions/concrete/web/_permissions_web.dart';
import 'package:flutter_base_rootstrap/devices/permissions/concrete/mobile/_permissions_ios.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/app_platform.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';
import 'package:flutter_base_rootstrap/devices/platform/concrete/_app_platform_impl.dart'
    if (dart.library.io) 'package:flutter_base_rootstrap/devices/platform/concrete/mobile_desk/_app_platform_impl.dart'
    if (dart.library.html) 'package:flutter_base_rootstrap/devices/platform/concrete/web/_app_platform_impl.dart';
import 'package:flutter_base_rootstrap/devices/platform/concrete/_platform_info_impl.dart';
import 'package:flutter_base_rootstrap/domain/bloc/app/app_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/auth/auth_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/get_products/get_products_cubit.dart';
import 'package:flutter_base_rootstrap/domain/bloc/login/login_cubit.dart';
import 'package:flutter_base_rootstrap/domain/repositories/auth_repository.dart';
import 'package:flutter_base_rootstrap/domain/repositories/common_repository.dart';
import 'package:flutter_base_rootstrap/domain/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';
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

final getIt = GetIt.instance;

Future<void> initialize() async {
  final pref = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(pref);
  getIt.registerSingleton<Preferences>(PreferencesImpl(getIt()));
  getIt.registerSingleton<AppPlatform>(AppPlatformImpl());
  getIt.registerLazySingleton<PlatformInfo>(() => PlatformInfoImpl(getIt()));
  getIt.registerLazySingleton<PermissionManager>(() {
    final platforms = getIt<AppPlatform>();
    if (platforms.isIOS) {
      return AppPermissionsIOs();
    }

    return AppPermissions();
  });

  //Network
  getIt.registerLazySingleton<Dio>(() => NetworkConfig.provideDio());
  //Data Sources
  getIt.registerLazySingleton<ProductDataSource>(
    () => ProductDataSourceImpl(getIt()),
  );
  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<CommonRepository>(
    () => CommonRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );

  //Cubits
  getIt.registerFactory(() => AppCubit(getIt()));
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => GetProductsCubit(getIt()));
}
