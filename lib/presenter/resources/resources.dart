import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presenter/themes/spacing.dart';
import 'package:flutter_svg/svg.dart';

part 'dim.dart';

part 'images.dart';

extension SpacingOnWidget on Widget {
  Spacing get spacing => Spacing();
}

extension SpacingOnStateWidget on State {
  Spacing get spacing => Spacing();
}
