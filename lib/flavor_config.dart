enum Flavor { development, staging, production }

class FlavorValues {
  FlavorValues({
    this.baseUrl,
  });

  final String? baseUrl;
}

class FlavorConfig {
  factory FlavorConfig({
    required appFlavor,
    flavorValues,
  }) {
    _instance = FlavorConfig._internal(appFlavor, flavorValues);
    return _instance!;
  }

  FlavorConfig._internal(this.appFlavor, this.flavorValues);

  final Flavor appFlavor;
  final FlavorValues? flavorValues;
  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance ??= FlavorConfig(
      appFlavor: Flavor.development,
      flavorValues: FlavorValues(),
    );
  }

  static bool get isDevelopment => _instance?.appFlavor == Flavor.development;
  static bool get isProduction => _instance?.appFlavor == Flavor.production;
  static bool get isStaging => _instance?.appFlavor == Flavor.staging;
}
