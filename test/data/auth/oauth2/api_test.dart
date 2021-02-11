import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_template/data/auth/oauth2/api.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('OAuth2TokenApi', () {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dioAdapter = DioAdapter();
    final dio = Dio();
    dio.httpClientAdapter = dioAdapter;
    final api = OAuth2TokenApi(dio);

    group('Given working API', () {
      final response = {
        'accessToken': 'token',
        'refreshToken': 'refreshToken',
        'createdAt': now,
        'expirationPeriod': 1000
      };
      setUp(() {
        dioAdapter
            .onPost('oauth/token')
            .reply(200, jsonEncode(response))
            .onPost('oauth/refresh')
            .reply(200, jsonEncode(response));
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

    group('Given failing API', () {
      setUp(() {
        dioAdapter
            .onPost('oauth/token')
            .reply(400, 'error')
            .onPost('oauth/refresh')
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
}
