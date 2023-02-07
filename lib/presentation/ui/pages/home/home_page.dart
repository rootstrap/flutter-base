import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/resources/resources.dart';
import 'package:go_router/go_router.dart';

GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatelessWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _mainScaffoldKey,
        appBar: AppBar(
          title: const Text("TEST APP"),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing.s),
              const _DrawerItem("Home", "/main"),
              SizedBox(height: spacing.s),
              const _DrawerItem("Notifications", "/notifications"),
              SizedBox(height: spacing.s),
              const _DrawerItem("Settings", "/settings"),
              SizedBox(height: spacing.s),
              const _DrawerItem("Post Details 123", "/main/post/123"),
              SizedBox(height: spacing.s),
              const _DrawerItem("LOGIN", "/auth"),
            ],
          ),
        ),
        body: child,
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final String route;

  const _DrawerItem(this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.s),
      height: Dimen.primaryButtonHeight,
      child: OutlinedButton(
        onPressed: () => _navTo(context, route),
        child: Text(title),
      ),
    );
  }

  void _navTo(BuildContext context, String route) {
    context.go(route);
    _mainScaffoldKey.currentState?.closeDrawer();
  }
}
