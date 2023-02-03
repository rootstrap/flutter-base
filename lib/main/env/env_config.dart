class EnvConfig {
  static const apiKey = String.fromEnvironment('API_KEY', defaultValue: "NA");
}

enum Flavor { dev, qa, prod }

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
