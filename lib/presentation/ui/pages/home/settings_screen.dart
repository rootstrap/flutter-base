import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final String profileName;

  const SettingsPage({super.key, required this.profileName});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Settings page for $profileName"),
      ),
    );
  }
}
