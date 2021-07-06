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

    group('given working API', () {
      final response = {
        'access_token': 'token',
        'refresh_token': 'refreshToken',
        'created_at': now,
        'expires_in': 1000
      };
      setUp(() {
        dioAdapter
          ..onPost('oauth/token', (request) => request.reply(200, response),
              queryParameters: {'grant_type': 'password'}, data: Matchers.any)
          ..onPost('oauth/token', (request) => request.reply(200, response),
              queryParameters: {'grant_type': 'refresh_token'},
              data: Matchers.any);
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
          ..onPost('oauth/token', (request) => request.reply(400, 'error'),
              queryParameters: {'grant_type': 'password'}, data: Matchers.any)
          ..onPost('oauth/token', (request) => request.reply(400, 'error'),
              queryParameters: {'grant_type': 'refresh_token'},
              data: Matchers.any);
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
