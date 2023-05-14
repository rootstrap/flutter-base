import 'package:flutter/widgets.dart';
import 'package:flutter_base_rootstrap/di/di_init.dart';
import 'package:flutter_base_rootstrap/domain/bloc/get_products/get_products_cubit.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/home/home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetProductsCubit>()..fetchProducts(),
      child: const HomeView(),
    );
  }
}
