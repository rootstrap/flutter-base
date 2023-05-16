import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/di/di_init.dart';
import 'package:flutter_base_rootstrap/domain/bloc/login/login_cubit.dart';
import 'package:flutter_base_rootstrap/presentation/ui/pages/login/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
      child: const LoginView(),
    );
  }
}
