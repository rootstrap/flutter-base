import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/resources/locale/localize.dart';
import 'package:flutter_base_rootstrap/resources/localization.dart';
import 'package:flutter_base_rootstrap/theme/spacing.dart';
import 'package:flutter_svg/svg.dart';

part 'dim.dart';

part 'images.dart';

/// Import this file and get access to all resource
///
///
/// Get the string resource:
/// e.g: context.getString(Localize.app_name)
/// e.g: context.getString(Localize.other, ['param1', 'param2'])
extension ContextString on BuildContext {
  String getString(
    Localize localize, {
    List<String>? params,
  }) =>
      AppLocalizations.of(this).getString(localize, params);
}

extension SpacingOnWidget on Widget {
  Spacing get spacing => Spacing(4.0);
}
