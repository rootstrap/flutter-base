import 'package:app/presentation/resources/resources.dart';
import 'package:app/presentation/themes/local_theme.dart';
import 'package:domain/env/env_config.dart';
import 'package:domain/services/environment_service.dart';
import 'package:flutter/material.dart';

import '../../../main/init.dart';

class EnvironmentSelector extends StatelessWidget {
  EnvironmentSelector({
    super.key,
  });

  final EnvironmentService environmentService = getIt<EnvironmentService>();

  DropdownMenuItem<String> _item(
          String value, String label, TextStyle textStyle) =>
      DropdownMenuItem<String>(
        value: value,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xs),
          child: Text(label, style: textStyle),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary.v0);

    final items = <DropdownMenuItem<String>>[
      _item(EnvConfig.kDevEnv, 'Development', textStyle!),
      _item(EnvConfig.kQaEnv, 'QA', textStyle),
      _item(EnvConfig.kProdEnv, 'Production', textStyle),
    ];

    return DropdownButtonFormField<String>(
      initialValue: EnvConfig.env,
      style: textStyle,
      decoration: InputDecoration(
        labelText: 'Environment',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.settings),
        labelStyle: textStyle,
      ),
      items: items,
      onChanged: (value) => environmentService.setEnvironment(value!),
    );
  }
}
