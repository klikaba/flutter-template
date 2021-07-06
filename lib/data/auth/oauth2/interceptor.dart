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
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final header = options.headers[_authHeader];

    if (header != null) {
      return handler.next(options);
    }

    var token = _tokenStorage.getToken();

    if (token == null) {
      return handler.next(options);
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

    return handler.next(options);
  }

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.type != DioErrorType.response ||
        error.response.statusCode != 401) {
      return handler.next(error);
    }

    final header = error.requestOptions.headers[_authHeader] as String;

    // There was an auth attempt but it failed
    if (header.length < 7 || !header.startsWith('Bearer')) {
      // Bad auth request, we should not attempt to fix it
      developer.log('Bad auth request was made. Authorization header: $header');
      return handler.next(error);
    }

    // get token - remove prefix
    // compare with stored token
    final sentToken = header.replaceFirst('Bearer', '');
    final storedToken = _tokenStorage.getToken();

    if (storedToken == null) {
      developer.log("No token stored. Can't attempt auth");
      return handler.next(error);
    }

    if (sentToken != storedToken.accessToken) {
      // Sent token is not the same as stored one
      // Retry with stored one
      return await _retryWithToken(
          error.requestOptions, storedToken.accessToken, handler);
    }

    if (!storedToken.isExpired()) {
      // Stored token is the same as sent one
      // But it hasn't expired
      // Seems like a bad token - abort
      developer.log('Bad token stored');
      return handler.next(error);
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
    return _retryWithToken(error.requestOptions, newToken.accessToken, handler);
  }

  void _retryWithToken(RequestOptions originalRequest, String token,
      ErrorInterceptorHandler handler) async {
    originalRequest.headers[_authHeader] = 'Bearer $token';
    return _dio
        .fetch(originalRequest)
        .then((r) => handler.resolve(r))
        .catchError((error, stackTrace) => handler.reject(error));
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
