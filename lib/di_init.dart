import 'package:flutter_base_rootstrap/devices/platform/abstract/app_platform.dart';
import 'package:flutter_base_rootstrap/devices/platform/abstract/platform_info.dart';
import 'package:flutter_base_rootstrap/devices/platform/concrete/_app_platform_impl.dart'
    if (dart.library.io) 'package:flutter_base_rootstrap/devices/platform/concrete/mobile_desk/_app_platform_impl.dart'
    if (dart.library.html) 'package:flutter_base_rootstrap/devices/platform/concrete/web/_app_platform_impl.dart';
import 'package:flutter_base_rootstrap/devices/platform/concrete/_platform_info_impl.dart';
import 'package:flutter_base_rootstrap/domain/services/abstract/service_class.dart';
import 'package:flutter_base_rootstrap/domain/services/concrete/service_class.dart';
import 'package:flutter_base_rootstrap/repository/abstract/repository_class.dart';
import 'package:flutter_base_rootstrap/repository/concrete/repository_class.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/concrete/preferences.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/abstract/remote_ds_class.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/concret/remote_ds_class.dart';
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
  getIt.registerSingleton<RemoteDsExample>(RemoteDsExampleImpl());
  getIt.registerSingleton<AppPlatform>(AppPlatformImpl());
  getIt.registerLazySingleton<PlatformInfo>(() => PlatformInfoImpl(getIt()));
  getIt.registerFactory<RepositoryExample>(
    () => (RepositoryExampleImpl(getIt())),
  );
  getIt.registerLazySingleton<ServiceExample>(
    () => ServiceExampleImpl(getIt()),
  );
  /*getIt.registerLazySingletonAsync<ServiceExample>(() async {
    //DO SOMETHING AWESOME HERE
    return ServiceExampleImpl(getIt());
  })*/
}
