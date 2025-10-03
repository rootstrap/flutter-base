import 'package:app/main/app.dart';
import 'package:common/init.dart';
import 'package:data/init.dart';
import 'package:domain/init.dart';
import 'package:example_domain/init.dart';
import 'package:example_data/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:url_strategy/url_strategy.dart';

import 'env/env_config.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  setHashUrlStrategy();
  runApp(const App());
}

final getIt = GetIt.instance;

Future<void> initialize() async {
  await dotenv.load(fileName: FlavorConfig.getEnvFilePath());
  await CommonInit.initialize(getIt);
  await DataInit.initialize(getIt);
  await DomainInit.initialize(getIt);

  // Example Module init
  await ExampleDataInit.initialize(getIt);
  await ExampleDomainInit.initialize(getIt);
}
