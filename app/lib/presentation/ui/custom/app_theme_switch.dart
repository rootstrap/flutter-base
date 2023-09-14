import 'package:app/presentation/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:domain/bloc/app/app_cubit.dart';
import 'package:domain/models/theme_type.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppThemeSwitch extends StatefulWidget {
  const AppThemeSwitch({Key? key}) : super(key: key);

  @override
  State<AppThemeSwitch> createState() => _AppThemeSwitchState();
}

class _AppThemeSwitchState extends State<AppThemeSwitch> {
  _AppThemeSwitchState();

  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    ThemeType theme = context.select<AppCubit, ThemeType>(
      (value) => value.state.themeType,
    );
    _isDark = theme == ThemeType.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: theme == ThemeType.dark,
          activeTrackColor: Colors.grey,
          onChanged: (value) {
            setState(() {
              _isDark = value;
            });
            context
                .read<AppCubit>()
                .updateTheme(value ? ThemeType.dark : ThemeType.light);
          },
        ),
        const SizedBox(width: 12.0),
        SizedBox(
          width: 44,
          height: 44,
          child: _isDark ? Images.modeNight.get() : Images.modeDay.get(),
        ).animate(target: _isDark ? 1 : 0).fade(end: 1).scaleXY(end: 1.1),
        const SizedBox(width: 12.0),
        Stack(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Images.bell.get(),
            )
                .animate(
                  //onPlay: (controller) => controller.repeat(),
                )
                .shake(duration: Duration(milliseconds: _isDark ? 1 : 500)),
            if (!_isDark)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "5",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ).animate().scaleXY(
                      begin: 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    ).then().shake(),
              ),
          ],
        ),
      ],
    );
  }
}
