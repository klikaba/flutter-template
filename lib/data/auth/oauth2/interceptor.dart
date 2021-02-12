import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'api.dart';
import 'token.dart';

const _authHeader = 'Authorization';

class OAuth2Interceptor extends Interceptor {
  // This dio represents instance of Dio this interceptor is added to
  // Needed to be able to lock interceptors, as well as retry requests
  final Dio _dio;
  final OAuth2TokenStorage _tokenStorage;
  final OAuth2TokenRefresher _tokenRefresher;

  OAuth2Interceptor(this._dio, this._tokenStorage, this._tokenRefresher);

  @override
  Future onRequest(RequestOptions options) async {
    final header = options.headers[_authHeader];

    if (header != null) {
      return options;
    }

    var token = _tokenStorage.getToken();

    if (token == null) {
      return options;
    }

    if (token.isExpired()) {
      _dio.lock();
      try {
        // Reload token and check it, to ensure it was not
        // refreshed with some other request
        token = _tokenStorage.getToken();
        if (token != null && token.isExpired()) {
          token = await _tokenRefresher.refreshToken();
        }
      } finally {
        _dio.unlock();
      }
    }

    options.headers[_authHeader] = 'Bearer ${token.accessToken}';

    return options;
  }

  @override
  Future onResponse(Response response) async {}

  @override
  Future onError(DioError error) async {
    if (error.type != DioErrorType.RESPONSE ||
        error.response.statusCode != 401) {
      return error;
    }

    final header = error.request.headers[_authHeader] as String;

    // There was an auth attempt but it failed
    if (header.length < 7 || !header.startsWith('Bearer')) {
      // Bad auth request, we should not attempt to fix it
      developer.log('Bad auth request was made. Authorization header: $header');
      return error;
    }

    // get token - remove prefix
    // compare with stored token
    final sentToken = header.replaceFirst('Bearer', '');
    final storedToken = _tokenStorage.getToken();

    if (storedToken == null) {
      developer.log("No token stored. Can't attempt auth");
      return error;
    }

    if (sentToken != storedToken.accessToken) {
      // Sent token is not the same as stored one
      // Retry with stored one
      return _retryWithToken(error.request, storedToken.accessToken);
    }

    if (!storedToken.isExpired()) {
      // Stored token is the same as sent one
      // But it hasn't expired
      // Seems like a bad token - abort
      developer.log('Bad token stored');
      return error;
    }

    _dio.lock();
    // Reload token and check it, to ensure it was not
    // refreshed with some other request
    var newToken = _tokenStorage.getToken();
    if (newToken != null && newToken.isExpired()) {
      newToken = await _tokenRefresher.refreshToken();
    }
    _dio.unlock();
    // retry with new token
    return _retryWithToken(error.request, newToken.accessToken);
  }

  Future<Response> _retryWithToken(
      RequestOptions originalRequest, String token) async {
    originalRequest.headers[_authHeader] = 'Bearer $token';
    return _dio.request(originalRequest.path, options: originalRequest);
  }
}

class OAuth2TokenRefresher {
  final OAuth2TokenStorage _tokenStorage;
  final OAuth2TokenApi _api;
  final OAuth2TokenRequestFactory _requestFactory;

  OAuth2TokenRefresher(this._api, this._tokenStorage, this._requestFactory);

  Future<OAuth2Token> refreshToken() async {
    final oldToken = _tokenStorage.getToken();
    if (oldToken != null && oldToken.isExpired()) {
      final newToken = await _api.refreshToken(
          _requestFactory.makeRefreshRequest(oldToken.refreshToken));

      if (newToken == null) {
        throw AssertionError(
            'Response body should not be null if call was successful');
      }

      _tokenStorage.saveToken(newToken);
      return newToken;
    } else {
      if (oldToken == null) {
        throw StateError('Stored token is null!');
      }
      return oldToken;
    }
  }
}
