/// Base authorization token
///
/// Only provides a token which can be used to authorize access
abstract class AuthToken {
  String get tokenString;
}

/// Represents auth token that can expire
abstract class ExpirableToken extends AuthToken {
  bool isExpired();
}

/// Represents expirable auth token that can be refreshed
abstract class RefreshableToken extends ExpirableToken {
  String get refreshTokenString;
}
