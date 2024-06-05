
import 'package:example_data/repositories/product_repository_impl.dart';
import 'package:example_domain/repositories/product_repository.dart';

import 'package:get_it/get_it.dart';

import 'data_sources/remote/abstract/product_data_source.dart';
import 'data_sources/remote/concrete/product_data_source_impl.dart';

class ExampleDataInit {
  static Future<void> initialize(GetIt getIt) async {

    getIt.registerLazySingleton<ProductDataSource>(
      () => ProductDataSourceImpl(getIt()),
    );

    //Repositories
    getIt.registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(getIt()),
    );
  }
}
