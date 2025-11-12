import 'package:app/main/init.dart';
import 'package:domain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/ui/custom/app_theme_switch.dart';

class HomeView extends StatelessWidget {
  AuthService get _authService => getIt();

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _authService.onLogout(),
            icon: const Icon(Icons.logout),
          ),
          const AppThemeSwitch(),
        ],
      ),
      body: const Text('Home Page'),
    );
  }
}
