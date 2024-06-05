import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
//import 'package:data/init.dart';
import 'package:domain/services/AuthService.dart';
import 'package:get_it/get_it.dart';

class DomainInit {
  static Future<void> initialize(GetIt getIt) async {
    //await DataInit.initialize(getIt);

    //Cubits
    getIt.registerSingleton(AppCubit(getIt()));
    getIt.registerSingleton(SessionCubit());

    //Services
    getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  }
}
