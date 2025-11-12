import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class DomainInit {
  static Future<void> initialize(GetIt getIt) async {
    //Cubits
    getIt.registerSingleton(AppCubit(getIt()));
    getIt.registerSingleton(AuthCubit());

    //Services
    getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  }
}
