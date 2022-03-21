enum Flavor {
  DEVELOPMENT,
  PRODUCTION,

  // Flavor specific configuration
}

class Config {
  static late Flavor appFlavor;
  static late String baseUrl;
  static late String clientId;
  static late String clientSecret;
  static late bool enableLogs;
}
