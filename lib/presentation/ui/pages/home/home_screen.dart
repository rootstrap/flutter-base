import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/presentation/bloc/auth_bloc.dart';
import 'package:flutter_base_rootstrap/presentation/resources/resources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          title: const Text("TEST NAVIGATION APP"),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing.s),
              _DrawerItem(
                "Home",
                () => _navTo(context, "/main"),
              ),
              SizedBox(height: spacing.s),
              _DrawerItem(
                "Notifications",
                () => _navTo(context, "/notifications"),
              ),
              SizedBox(height: spacing.s),
              _DrawerItem(
                "Settings",
                () {
                  _mainScaffoldKey.currentState?.closeDrawer();
                  context.goNamed(
                    "profile_sub",
                    queryParams: {'profileName': "Amaury Ricardo"},
                  );
                },
              ),
              SizedBox(height: spacing.s),
              _DrawerItem(
                "Post Details",
                () {
                  _mainScaffoldKey.currentState?.closeDrawer();
                  context.goNamed(
                    "postDetails",
                    params: {'id': "asbdasdasom"},
                  );
                  //_navTo(context, "/main/post/123");
                },
              ),
              SizedBox(height: spacing.s),
              _DrawerItem(
                "LOGOUT",
                () => BlocProvider.of<AuthBloc>(context).logout(),
              ),
            ],
          ),
        ),
        body: child,
      ),
    );
  }

  void _navTo(BuildContext context, String route) {
    context.go(route);
    _mainScaffoldKey.currentState?.closeDrawer();
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerItem(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.s),
      height: Dimen.primaryButtonHeight,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }
}
