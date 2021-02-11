/// Represents access information of a client
///
/// This should be used to authorize application access
abstract class ClientConfig {
  String get clientId;
  String get clientSecret;
}
