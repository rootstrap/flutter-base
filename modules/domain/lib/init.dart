import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:domain/bloc/login/login_cubit.dart';
import 'package:domain/repositories/auth_repository.dart';
import 'package:domain/repositories/common_repository.dart';
import 'package:domain/repositories/concrete/auth_repository_impl.dart';
import 'package:domain/repositories/concrete/common_repository_impl.dart';
import 'package:domain/repositories/concrete/product_repository_impl.dart';
import 'package:domain/repositories/product_repository.dart';
import 'package:data/init.dart';
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
    getIt.registerFactory(() => AppCubit(getIt()));
    getIt.registerFactory(() => AuthCubit(getIt()));
    getIt.registerFactory(() => LoginCubit(getIt()));
    getIt.registerSingleton(GetProductsCubit());

    //Services
    getIt.registerSingleton(ProductService(getIt(), getIt()));
  }
}
