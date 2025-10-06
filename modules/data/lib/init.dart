import 'package:data/network/config/network_config.dart';
import 'package:data/preferences/preferences.dart';
import 'package:data/preferences/preferences_impl.dart';
import 'package:data/repositories/auth_repository_impl.dart';
import 'package:data/repositories/common_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/repositories/common_repository.dart';
import 'package:domain/services/environment_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/config/environment_service_impl.dart';

class DataInit {
  static Future<void> initialize(GetIt getIt) async {
    final pref = await SharedPreferences.getInstance();

    getIt.registerSingleton<SharedPreferences>(pref);
    getIt.registerSingleton<Preferences>(PreferencesImpl(getIt()));

    //Network
    getIt.registerLazySingleton<Dio>(() => NetworkConfig.provideDio());
    getIt.registerLazySingleton<EnvironmentService>(() => EnvironmentServiceImpl(getIt()));

    //Data Sources

    //Repositories
    getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(getIt(), getIt()),
    );
    getIt.registerLazySingleton<CommonRepository>(
          () => CommonRepositoryImpl(getIt()),
    );
  }
}
