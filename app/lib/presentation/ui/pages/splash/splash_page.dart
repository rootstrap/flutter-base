import 'package:app/main/init.dart';
import 'package:domain/services/AuthService.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthService get _authService => getIt();

  @override
  void initState() {
    super.initState();
    _authService.onValidate();
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
