import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/ui/pages/auth/sign_up/sign_up_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: kIsWeb ? Dimen.authFormMaxWidth : double.infinity,
          ),
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(Dimen.spacingM),
              child: SignUpForm(),
            ),
          ),
        ),
      ),
    );
  }
}
