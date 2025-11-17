import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/ui/pages/auth/login/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Dimen.loginFormMaxWidth,
          ),
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(Dimen.spacingM),
              child: LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
