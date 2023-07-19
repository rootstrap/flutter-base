import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final bool isLoading;
  final Color? color;

  const LoadingScreen({
    Key? key,
    required this.isLoading,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: isLoading
          ? Container(
              color: Colors.transparent,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: color,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
