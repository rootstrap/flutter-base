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
}
