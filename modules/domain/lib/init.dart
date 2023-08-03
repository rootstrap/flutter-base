import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/repositories/common_repository.dart';
import 'package:domain/repositories/concrete/auth_repository_impl.dart';
import 'package:domain/repositories/concrete/common_repository_impl.dart';
import 'package:domain/repositories/concrete/product_repository_impl.dart';
import 'package:domain/repositories/product_repository.dart';
import 'package:data/init.dart';
import 'package:domain/services/AuthService.dart';
import 'package:domain/services/ProductService.dart';
import 'package:get_it/get_it.dart';

class DomainInit {
  static Future<void> initialize(GetIt getIt) async {
    await DataInit.initialize(getIt);

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
    getIt.registerSingleton(AppCubit(getIt()));
    getIt.registerSingleton(SessionCubit());
    getIt.registerSingleton(GetProductsCubit());

    //Services
    getIt.registerLazySingleton(() => ProductService(getIt(), getIt()));
    getIt.registerLazySingleton(() => AuthService(getIt(), getIt()));
  }
}
