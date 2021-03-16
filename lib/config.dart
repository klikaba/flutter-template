enum Flavor {
  DEVELOPMENT,
  PRODUCTION,

  // Flavor specific configuration
}

class Config {
  static Flavor appFlavor;
  static String baseUrl;
  static String clientId;
  static String clientSecret;
  static bool enableLogs;
}
