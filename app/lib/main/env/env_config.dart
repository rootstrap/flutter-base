import 'package:domain/env/env_config.dart';

enum Flavor { dev, qa, prod }

class FlavorValues {

  FlavorValues();
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      flavor.toString(),
      values,
    );
    switch(flavor) {
      case Flavor.dev:
        EnvConfig.env = EnvConfig.kDevEnv;
        break;
      case Flavor.qa:
        EnvConfig.env = EnvConfig.kQaEnv;
        break;
      case Flavor.prod:
        EnvConfig.env = EnvConfig.kProdEnv;
        break;
    }
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  static FlavorConfig get instance => _instance!;

  static bool isProduction() => instance.flavor == Flavor.prod;

  static bool isDevelopment() => instance.flavor == Flavor.dev;

  static bool isQA() => instance.flavor == Flavor.qa;

  /// Returns the environment file path (single .env file for all flavors)
  ///
  /// SETUP INSTRUCTIONS:
  /// 1. Navigate to app/env/ directory
  /// 2. Create a .env file (must be in .gitignore):
  ///    cp .env.example .env
  /// 3. Add your environment variables with flavor suffixes:
  ///    API_URL_DEV=https://dev-api.example.com
  ///    API_URL_QA=https://qa-api.example.com
  ///    API_URL_PROD=https://api.example.com
  /// 4. The active flavor determines which suffix is used (_DEV, _QA, _PROD)
  /// 5. Access variables in domain/lib/env/env_config.dart using:
  ///    static String get apiUrl => dotenv.env['API_URL_$env']?.toString() ?? '';
  ///    (The $env automatically appends DEV, QA, or PROD based on active flavor)
  /// 6. Go to pubspec.yaml and add the following:
  ///    assets:
  ///     - env/.env

  static String getEnvFilePath() {
    return 'env/.env.example';
  }
}
