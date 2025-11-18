import 'package:flutter/material.dart';
import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/models/theme_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppThemeSwitch extends StatelessWidget {
  const AppThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeType theme = context.select<AppCubit, ThemeType>(
      (value) => value.state.themeType,
    );

    return Switch(
      value: theme == ThemeType.dark,
      thumbIcon: const WidgetStatePropertyAll(Icon(Icons.brightness_6)),
      onChanged: (value) {
        context
            .read<AppCubit>()
            .updateTheme(value ? ThemeType.dark : ThemeType.light);
      },
    );
  }
}
