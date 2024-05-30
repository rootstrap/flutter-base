import 'package:example_domain/services/ProductService.dart';
import 'package:get_it/get_it.dart';
import 'package:example_data/init.dart';
import 'bloc/get_products/get_products_cubit.dart';

class ExampleDomainInit {
  static Future<void> initialize(GetIt getIt) async {
    await ExampleDataInit.initialize(getIt);

    getIt.registerSingleton(GetProductsCubit());

    //Services
    getIt.registerLazySingleton(() => ProductService(getIt(), getIt()));
  }
}
