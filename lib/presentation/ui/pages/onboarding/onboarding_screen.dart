import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  final Widget child;

  const OnBoardingPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: child,
    );
  }
}
