import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';
import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/bloc/app/app_state.dart';
import 'package:domain/bloc/auth/auth_cubit.dart';
import 'package:domain/models/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class DebugBanner extends StatelessWidget {
  final Widget child;
  const DebugBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      child: Column(
        children: [
          Container(
            color: colorScheme.error.withAlpha(120),
            child: Row(
              children: [
                Icon(Icons.bug_report, color: colorScheme.onError),
                const Gap(Dimen.spacingS),
                Text(
                  S.of(context).debugModeLabel,
                  style:
                      textTheme.bodyLarge?.copyWith(color: colorScheme.onError),
                ),
                const Spacer(),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return DropdownButton<AppLang>(
                      value: state.appLang,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimen.spacingS,
                      ),
                      underline: Container(),
                      icon: Icon(Icons.language, color: colorScheme.onError),
                      onChanged: (AppLang? newLang) {
                        if (newLang != null) {
                          context.read<AppCubit>().updateAppLang(newLang);
                        }
                      },
                      items: AppLang.values.map((AppLang lang) {
                        return DropdownMenuItem<AppLang>(
                          value: lang,
                          child: Text(lang.name.toUpperCase()),
                        );
                      }).toList(),
                    );
                  },
                ),
                const Gap(Dimen.spacingS),
                const AppThemeSwitch(),
                const Gap(Dimen.spacingS),
                TextButton(
                  onPressed: () => resetApp(context),
                  child: Text(S.of(context).debugModeResetApp),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  void resetApp(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).debugModeResetAppTitle),
          content: Text(S.of(context).debugModeResetAppMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(S.of(context).debugModeCancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await context.read<AppCubit>().resetApp();
                await context.read<AuthCubit>().logOut();
              },
              child: Text(S.of(context).debugModeConfirm),
            ),
          ],
        );
      },
    );
  }
}
