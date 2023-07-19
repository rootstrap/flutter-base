import 'package:app/main/init.dart';
import 'package:flutter/material.dart';
import 'package:domain/bloc/login/login_cubit.dart';
import 'package:app/presentation/ui/pages/login/login_view.dart';
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
