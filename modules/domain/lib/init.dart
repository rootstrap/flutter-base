import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:data/init.dart';
import 'package:domain/services/AuthService.dart';
import 'package:domain/services/ProductService.dart';
import 'package:get_it/get_it.dart';

class DomainInit {
  static Future<void> initialize(GetIt getIt) async {
    await DataInit.initialize(getIt);

    //Cubits
    getIt.registerSingleton(AppCubit(getIt()));
    getIt.registerSingleton(SessionCubit());
    getIt.registerSingleton(GetProductsCubit());

    //Services
    getIt.registerLazySingleton(() => ProductService(getIt(), getIt()));
    getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  }
}
