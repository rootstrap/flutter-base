import 'package:flutter/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppAnimations {
  static final transitionIn = <Effect>[
    FadeEffect(duration: 1000.ms, curve: Curves.easeOut),
    const ScaleEffect(begin: Offset(0.8, 0), curve: Curves.easeIn),
  ];
}
