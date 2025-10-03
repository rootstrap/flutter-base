import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String kDevEnv = "DEV";
  static const String kProdEnv = "PROD";
  static const String kQaEnv = "QA";

  static String env = kDevEnv;

  static String get envConfigFile => 'env/.settings.example';

  static String get apiUrl => dotenv.env['API_URL_$env']?.toString() ?? '';
}
