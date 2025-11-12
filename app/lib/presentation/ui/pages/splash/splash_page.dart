import 'package:app/main/init.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// Given this is a global cubit, we can access it directly from getIt
  /// otherwise use context.read<AuthCubit>() to read the Cubit under that context
  AuthCubit get _authCubit => getIt();

  @override
  void initState() {
    super.initState();

    /// Add post frame callback to avoid calling bloc methods during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      _authCubit.onValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
