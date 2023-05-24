import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/di/di_init.dart';
import 'package:flutter_base_rootstrap/main/app.dart';
import 'package:url_strategy/url_strategy.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  setHashUrlStrategy();
  runApp(const App());
}
