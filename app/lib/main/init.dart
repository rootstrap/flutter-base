import 'package:app/main/app.dart';
import 'package:common/init.dart';
import 'package:data/init.dart';
import 'package:domain/init.dart';
import 'package:example_domain/init.dart';
import 'package:example_data/init.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notifications/init.dart';
import 'package:url_strategy/url_strategy.dart';

void init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  setHashUrlStrategy();
  runApp(const App());
}

final getIt = GetIt.instance;

Future<void> initialize() async {
  await CommonInit.initialize(getIt);
  await DataInit.initialize(getIt);
  await DomainInit.initialize(getIt);
  await NotificationsInit.initialize(getIt);

  // Example Module init
  await ExampleDomainInit.initialize(getIt);
  await ExampleDataInit.initialize(getIt);
}
