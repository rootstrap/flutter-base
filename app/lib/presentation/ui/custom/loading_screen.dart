import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Color? color;

  const LoadingScreen({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: color,
          ),
        ),
      ),
    );
  }
}
