import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/skeleton/presentation/bloc/skeleton/skeleton_cubit.dart';
import 'package:flutter_base_rootstrap/skeleton/presentation/pages/skeleton/skeleton_view.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkeletonPage extends StatelessWidget {
  const SkeletonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SkeletonCubit>(),
      child: const SkeletonView(),
    );
  }
}
