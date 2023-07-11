import 'package:data/data_sources/remote/abstract/product_data_source.dart';
import 'package:data/data_sources/remote/concrete/product_data_source_impl.dart';
import 'package:data/network/config/network_config.dart';
import 'package:data/preferences/preferences.dart';
import 'package:data/preferences/preferences_impl.dart';
import 'package:dio/dio.dart';
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
    getIt.registerLazySingleton<ProductDataSource>(
      () => ProductDataSourceImpl(getIt()),
    );
  }
}
