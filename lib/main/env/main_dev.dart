import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/main/env/env_config.dart';
import 'package:flutter_base_rootstrap/main/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.dev,
    values: FlavorValues(baseUrl: "https://demo_dev/web_api.json"),
  );
  init();
}
