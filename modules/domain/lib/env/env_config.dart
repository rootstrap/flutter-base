import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String kDevEnv = "DEV";
  static const String kProdEnv = "PROD";
  static const String kQaEnv = "QA";

  static String env = kDevEnv;

  static String get envConfigFile => 'env/.env.example';

  /// Supports both env file layouts:
  /// - one file per flavor (e.g. `env/.dev`) with an unsuffixed `API_URL`;
  /// - a single file with suffixed keys (`API_URL_DEV`, `API_URL_QA`,
  ///   `API_URL_PROD`) as in `env/.env.example`. A suffixed key wins.
  static String get apiUrl =>
      dotenv.env['API_URL_$env'] ?? dotenv.env['API_URL'] ?? '';
}
