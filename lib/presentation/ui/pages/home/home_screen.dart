import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey<ScaffoldState>();

class HomeCorePage extends StatelessWidget {
  final Widget child;

  const HomeCorePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _mainScaffoldKey,
        appBar: AppBar(
          title: const Text("TEST NAVIGATION APP"),
        ),
        body: child,
      ),
    );
  }
}
