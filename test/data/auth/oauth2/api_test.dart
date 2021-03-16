import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/data/auth/oauth2/api.dart';
import 'package:flutter_template/data/auth/config.dart';

class FakeConfig implements ClientConfig {
  @override
  String clientId;
  @override
  String clientSecret;
}

void main() {
  group('OAuth2TokenApi', () {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dioAdapter = DioAdapter();
    final dio = Dio();
    dio.httpClientAdapter = dioAdapter;
    final api = OAuth2TokenApi(dio);

    final passwordRequest = Request(
        route: 'oauth/token',
        method: RequestMethods.POST,
        queryParameters: {'grant_type': 'password'});
    final refreshRequest = Request(
        route: 'oauth/token',
        method: RequestMethods.POST,
        queryParameters: {'grant_type': 'refresh_token'});

    group('given working API', () {
      final response = {
        'accessToken': 'token',
        'refreshToken': 'refreshToken',
        'createdAt': now,
        'expirationPeriod': 1000
      };
      setUp(() {
        // Waiting for https://github.com/lomsa-dev/http-mock-adapter/pull/84
        dioAdapter
            .onRoute(passwordRequest.route, request: passwordRequest)
            .reply(200, response)
            .onRoute(refreshRequest.route, request: refreshRequest)
            .reply(200, response);
      });

      test('createToken should return OAuth2Token', () async {
        final result = await api.createToken(CreateOAuth2TokenRequest(
            username: 'test',
            password: 'test',
            clientId: 'test',
            clientSecret: 'test'));

        expect(result.accessToken, equals('token'));
        expect(result.refreshToken, equals('refreshToken'));
        expect(result.createdAt, equals(now));
        expect(result.expirationPeriod, equals(1000));
      });

      test('refreshToken should return OAuth2Token', () async {
        final result = await api.refreshToken(RefreshOAuth2TokenRequest(
            refreshToken: 'sometoken', clientId: 'test', clientSecret: 'test'));

        expect(result.accessToken, equals('token'));
        expect(result.refreshToken, equals('refreshToken'));
        expect(result.createdAt, equals(now));
        expect(result.expirationPeriod, equals(1000));
      });
    });

    group('given failing API', () {
      setUp(() {
        dioAdapter
            .onRoute(passwordRequest.route, request: passwordRequest)
            .reply(400, 'error')
            .onRoute(refreshRequest.route, request: refreshRequest)
            .reply(400, 'error');
      });
      test('createToken should fail', () async {
        expect(
            api.createToken(CreateOAuth2TokenRequest(
                username: 'test',
                password: 'test',
                clientId: 'test',
                clientSecret: 'test')),
            throwsException);
      });

      test('refreshToken should fail', () async {
        expect(
            api.refreshToken(RefreshOAuth2TokenRequest(
                refreshToken: 'test', clientId: 'test', clientSecret: 'test')),
            throwsException);
      });
    });
  });

  group('OAuth2TokenRequestFactory', () {
    group('given client config', () {
      final clientConfig = FakeConfig();
      clientConfig.clientId = 'testClientId';
      clientConfig.clientSecret = 'testClientSecret';
      final requestFactory = OAuth2TokenRequestFactory(clientConfig);

      test('it should use config for creation request', () {
        final result =
            requestFactory.makeCreateRequest('testUsername', 'testPassword');

        expect(result.clientId, equals(clientConfig.clientId));
        expect(result.clientSecret, equals(clientConfig.clientSecret));
        expect(result.username, equals('testUsername'));
        expect(result.password, equals('testPassword'));
      });

      test('it should use config for refresh request', () {
        final result = requestFactory.makeRefreshRequest('testRefreshToken');

        expect(result.clientId, equals(clientConfig.clientId));
        expect(result.clientSecret, equals(clientConfig.clientSecret));
        expect(result.refreshToken, equals('testRefreshToken'));
      });
    });
  });
}
