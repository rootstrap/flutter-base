import 'package:app/presentation/navigation/routers.dart';
import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/ui/components/primary_button.dart';
import 'package:common/core/resource.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:common/validators/form_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool agreeToTerms = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).titleLogin,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(Dimen.spacingL),
          Text(
            S.of(context).titleLoginSubtitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Gap(Dimen.spacingL),
          TextFormField(
            decoration: InputDecoration(
              labelText: S.of(context).labelEmail,
            ),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            controller: emailController,
            validator: (value) {
              if (!FormValidator.isEmail(value)) {
                return S.of(context).errorEmailInvalid;
              }

              return null;
            },
          ),
          const Gap(Dimen.spacingM),
          TextFormField(
            decoration: InputDecoration(
              labelText: S.of(context).labelPassword,
            ),
            obscureText: true,
            controller: passwordController,
            validator: (value) {
              if (!FormValidator.isStrongPassword(value)) {
                return S.of(context).errorPasswordWeak;
              }
              return null;
            },
          ),
          const Gap(Dimen.spacingM),
          Text(
            S.of(context).passwordInstructions,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Gap(Dimen.spacingM),
          TextButton(
            onPressed: () => setState(() {
              agreeToTerms = !agreeToTerms;
            }),
            child: Row(
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (value) => setState(() {
                    agreeToTerms = value ?? false;
                  }),
                ),
                Text(
                  S.of(context).labelAgreeToTerms,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Gap(Dimen.spacingS),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).hintTermsAndConditions),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info),
                )
              ],
            ),
          ),
          const Gap(Dimen.spacingM),
          BlocBuilder<AuthCubit, Resource>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state is RError) ...[
                    Text(
                      S.of(context).loginErrorInvalidCredentials,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                    ),
                    const Gap(Dimen.spacingM),
                  ],
                  PrimaryButton(
                    label: S.of(context).ctaLogin,
                    onPressed: () {
                      if ((_formKey.currentState?.validate() ?? false) &&
                          agreeToTerms) {
                        context.read<AuthCubit>().login(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                      }
                    },
                    isEnabled: agreeToTerms,
                    isLoading: state is RLoading,
                    trailingIcon: const Icon(Icons.login),
                  )
                ],
              );
            },
          ),
          const Gap(Dimen.spacingL),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimen.spacingS),
                child: Text("OR"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const Gap(Dimen.spacingM),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Routes.signup.go(context),
              child: Text(S.of(context).ctaSignUp.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
