import 'package:app/main/init.dart';
import 'package:flutter/widgets.dart';
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:app/presentation/ui/pages/home/home_view.dart';
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
