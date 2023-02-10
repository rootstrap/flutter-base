import 'package:flutter/material.dart';
import 'package:flutter_base_rootstrap/di/di_init.dart';
import 'package:flutter_base_rootstrap/main/my_app.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const MyApp());
}
