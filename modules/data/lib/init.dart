import 'package:data/network/config/network_config.dart';
import 'package:data/preferences/preferences.dart';
import 'package:data/preferences/preferences_impl.dart';
import 'package:data/repositories/auth_repository_impl.dart';
import 'package:data/repositories/common_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/repositories/common_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataInit {
  static Future<void> initialize(GetIt getIt) async {
    final pref = await SharedPreferences.getInstance();

    getIt.registerSingleton<SharedPreferences>(pref);
    getIt.registerSingleton<Preferences>(PreferencesImpl(getIt()));

    //Network
    getIt.registerLazySingleton<Dio>(() => NetworkConfig.provideDio());

    //Data Sources

    //Repositories
    getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(getIt()),
    );
    getIt.registerLazySingleton<CommonRepository>(
          () => CommonRepositoryImpl(getIt()),
    );
  }
}
