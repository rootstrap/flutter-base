import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/themes/spacing.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'dim.dart';

part 'images.dart';

extension SpacingOnWidget on Widget {
  Spacing get spacing => Spacing();
}

extension SpacingOnStateWidget on State {
  Spacing get spacing => Spacing();
}
