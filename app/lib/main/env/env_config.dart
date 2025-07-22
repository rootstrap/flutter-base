import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor {
  dev,
  qa,
  prod;

  static Flavor fromString(String value) {
    return Flavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => Flavor.dev,
    );
  }
}

class Environment {
  static String get clientSecret => dotenv.env['SECRET_KEY'] ?? '';

  static String? get portalUrl => dotenv.env['API_URL'];

  static String get envName => const String.fromEnvironment(
        'ENV',
        defaultValue: 'dev',
      );

  static String get envConfigFile => 'env/.$envName';
}

class FlavorValues {
  final String baseUrl;

  FlavorValues({required this.baseUrl});
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
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  static FlavorConfig get instance => _instance!;

  static bool isProduction() => instance.flavor == Flavor.prod;

  static bool isDevelopment() => instance.flavor == Flavor.dev;

  static bool isQA() => instance.flavor == Flavor.qa;
}
