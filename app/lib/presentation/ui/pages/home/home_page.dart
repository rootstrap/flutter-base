import 'package:app/main/init.dart';
import 'package:domain/services/ProductService.dart';
import 'package:flutter/widgets.dart';
import 'package:app/presentation/ui/pages/home/home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  ProductService get _productsService => getIt<ProductService>();

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _productsService.productsCubit,
      child: const HomeView(),
    );
  }
}
