import 'package:flutter/material.dart';
import 'package:app/main/env/env_config.dart';
import 'package:app/main/init.dart';
import 'package:domain/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.prod,
    values: FlavorValues(baseUrl: EnvConfig.apiUrl),
  );
  //Add your firebase configuration here
  /*await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "your_key",
      authDomain: "your_auth_domain.firebaseapp.com",
      databaseURL: "https://your_db_url.firebaseio.com",
      projectId: "your_project_id",
      storageBucket: "your_storage_bucket.appspot.com",
      // Add your messaging sender Id
      messagingSenderId: "000000000",
      // Add your App Id
      appId: "----------",
      // Add your measurementId
      measurementId: "G-21AWEQTWR",
    ),
  );*/
  init();
}
