import 'package:app/main/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app/main/env/env_config.dart';
import 'package:common/init.dart';
import 'package:data/init.dart';
import 'package:domain/init.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';


void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initialize();
  runApp(const App());
}

final getIt = GetIt.instance;

Future<void> initialize() async {
  await dotenv.load(fileName: Environment.envConfigFile);

  await CommonInit.initialize(getIt);
  await DataInit.initialize(getIt);
  await DomainInit.initialize(getIt);
}
