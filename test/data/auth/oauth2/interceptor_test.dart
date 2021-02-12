import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_template/data/auth/oauth2/api.dart';
import 'package:flutter_template/data/auth/oauth2/token.dart';
import 'package:flutter_template/data/auth/oauth2/interceptor.dart';

class MockOAuth2TokenApi extends Mock implements OAuth2TokenApi {}

class MockOAuth2TokenStorage extends Mock implements OAuth2TokenStorage {}

class MockOAuth2Token extends Mock implements OAuth2Token {}

class MockOAuth2TokenRefresher extends Mock implements OAuth2TokenRefresher {}

class MockDio extends Mock implements Dio {}

class MockOAuth2TokenRequestFactory extends Mock
    implements OAuth2TokenRequestFactory {}

void main() {
  group('OAuth2Interceptor', () {
    final dio = MockDio();
    final tokenStorage = MockOAuth2TokenStorage();
    final tokenRefresher = MockOAuth2TokenRefresher();
    final interceptor = OAuth2Interceptor(dio, tokenStorage, tokenRefresher);

    group('given request with Auth header', () {
      var request;
      var result;
      setUp(() async {
        request = RequestOptions(headers: {'Authorization': 'test'});
        result = await interceptor.onRequest(request);
      });

      test('it should not change request', () {
        expect(result, equals(request));
      });
    });

    group('given request without Auth header', () {
      var request;

      setUp(() {
        request = RequestOptions();
      });

      group('and no stored token', () {
        var result;
        setUp(() async {
          reset(tokenStorage);
          when(tokenStorage.getToken()).thenReturn(null);

          result = await interceptor.onRequest(request);
        });

        test('it should not change request', () {
          expect(result, equals(request));
        });
      });

      group('and valid stored token', () {
        final storedToken = MockOAuth2Token();
        var result;
        setUp(() async {
          reset(tokenStorage);
          reset(dio);
          when(tokenStorage.getToken()).thenReturn(storedToken);
          when(storedToken.accessToken).thenReturn('access');
          when(storedToken.isExpired()).thenReturn(false);

          result = await interceptor.onRequest(request);
        });

        test('it should add stored token to headers', () {
          expect(result.headers['Authorization'], equals('Bearer access'));
          verify(tokenStorage.getToken());
        });

        test('it should not lock interceptor', () {
          verifyNever(dio.lock());
        });

        test('it should not refresh token', () {
          verifyNever(tokenRefresher.refreshToken());
        });
      });

      group('and expired stored token', () {
        final storedToken = MockOAuth2Token();
        final newToken = MockOAuth2Token();
        var result;
        setUp(() async {
          reset(tokenStorage);
          reset(dio);
          reset(tokenRefresher);
          reset(storedToken);
          when(tokenStorage.getToken()).thenReturn(storedToken);
          when(storedToken.isExpired()).thenReturn(true);
          when(tokenRefresher.refreshToken()).thenAnswer((_) async => newToken);
          when(newToken.accessToken).thenReturn('refreshed access');

          result = await interceptor.onRequest(request);
        });

        test('it should add refreshed token to headers', () {
          expect(result.headers['Authorization'],
              equals('Bearer refreshed access'));
          verify(tokenStorage.getToken());
        });

        test('it should refresh token', () {
          verify(tokenRefresher.refreshToken());
        });

        test('it should lock and unlock interceptor', () {
          verifyInOrder([dio.lock(), dio.unlock()]);
        });
      });
    });

    group('given a non response error', () {
      final error = DioError(type: DioErrorType.SEND_TIMEOUT);
      var result;

      setUp(() async {
        result = await interceptor.onError(error);
      });

      test('it should pass down the error', () {
        expect(result, equals(error));
      });
    });

    group('given a non auth error', () {
      final error = DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 400));
      var result;

      setUp(() async {
        result = await interceptor.onError(error);
      });

      test('it should pass down the error', () {
        expect(result, equals(error));
      });
    });

    // TODO more error interceptor tests
  });
  group('OAuth2TokenRefresher', () {
    final api = MockOAuth2TokenApi();
    final tokenStorage = MockOAuth2TokenStorage();
    final requestFactory = MockOAuth2TokenRequestFactory();
    final refresher = OAuth2TokenRefresher(api, tokenStorage, requestFactory);

    setUp(() {
      when(requestFactory.makeRefreshRequest(any)).thenReturn(
          RefreshOAuth2TokenRequest(
              refreshToken: 'test',
              clientId: 'clientId',
              clientSecret: 'clientSecret'));
    });

    group('given no token stored', () {
      setUp(() {
        reset(tokenStorage);
        when(tokenStorage.getToken()).thenReturn(null);
      });

      test('refresh should fail', () {
        expect(refresher.refreshToken(), throwsStateError);
        verify(tokenStorage.getToken());
      });
    });

    group('given stored unexpired token', () {
      final token = MockOAuth2Token();
      setUp(() {
        reset(tokenStorage);
        when(tokenStorage.getToken()).thenReturn(token);
        when(token.isExpired()).thenReturn(false);
      });

      group('when refresh is called', () {
        var result;
        setUp(() async {
          reset(api);
          result = await refresher.refreshToken();
        });
        test('refresh should not request a new token', () {
          verify(tokenStorage.getToken());
          verifyZeroInteractions(api);
        });

        test('refresh should return old token', () {
          expect(result, equals(token));
        });
      });
    });

    group('given stored expired token', () {
      final token = MockOAuth2Token();
      setUp(() {
        reset(tokenStorage);
        when(tokenStorage.getToken()).thenReturn(token);
        when(token.isExpired()).thenReturn(true);
      });

      group('when refresh is called', () {
        var result;
        final newToken = MockOAuth2Token();
        setUp(() async {
          reset(api);
          when(api.refreshToken(any)).thenAnswer((_) async => newToken);
          result = await refresher.refreshToken();
        });
        test('refresh should request a new token', () {
          expect(result, equals(newToken));
          verify(api.refreshToken(any));
        });

        test('refresh should save new token', () {
          verify(tokenStorage.saveToken(newToken));
        });
      });
    });
  });
}
