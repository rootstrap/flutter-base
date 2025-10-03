import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'env/env_config.dart';

class DomainInit {
  static Future<void> initialize(GetIt getIt) async {
    await dotenv.load(fileName: EnvConfig.envConfigFile);
    //Cubits
    getIt.registerSingleton(AppCubit(getIt()));
    getIt.registerSingleton(AuthCubit());

    //Services
    getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  }
}
