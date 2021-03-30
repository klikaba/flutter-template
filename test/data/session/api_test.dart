import 'package:flutter_template/data/auth/oauth2/api.dart';
import 'package:flutter_template/data/auth/oauth2/token.dart';
import 'package:flutter_template/data/session/model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/data/session/api.dart';
import 'package:mockito/mockito.dart';

class MockTokenApi extends Mock implements OAuth2TokenApi {}

class MockTokenStorage extends Mock implements OAuth2TokenStorage {}

class MockFactory extends Mock implements OAuth2TokenRequestFactory {}

void main() {
  group('SessionRepository', () {
    final requestFactory = MockFactory();
    final storage = MockTokenStorage();
    final api = MockTokenApi();

    tearDown(() {
      reset(requestFactory);
      reset(storage);
      reset(api);
    });

    group('given working API', () {
      final token = OAuth2Token(1000, 0, 'access', 'refresh');
      final repository = SessionRepository(api, storage, requestFactory);
      setUp(() {
        when(api.createToken(any)).thenAnswer((_) => Future.value(token));
      });

      group('when logIn is called', () {
        final request = Credentials('test', 'test');

        setUp(() async {
          await repository.logIn(request);
        });

        test('it should request token', () {
          verify(requestFactory.makeCreateRequest('test', 'test'));
          verify(api.createToken(any));
        });

        test('it should store token', () {
          verify(storage.saveToken(token));
        });
      });

      group('when logOut is called', () {
        setUp(() async {
          await repository.logOut();
        });

        test('it should clear out token', () {
          verify(storage.clearToken());
        });
      });
    });

    group('given failing API', () {
      final repository = SessionRepository(api, storage, requestFactory);
      setUp(() {
        when(api.createToken(any)).thenThrow(Exception());
      });

      group('when logIn is called', () {
        final request = Credentials('test', 'test');

        test('it should return error', () {
          expect(repository.logIn(request), throwsException);
          verify(api.createToken(any));
        });

        test('it should not change token storage', () {
          expect(repository.logIn(request), throwsException);
          verifyNoMoreInteractions(storage);
        });
      });

      group('when logOut is called', () {
        setUp(() async {
          await repository.logOut();
        });

        test('it should clear out token', () {
          verify(storage.clearToken());
        });
      });
    });

    group('given stored token', () {
      final repository = SessionRepository(api, storage, requestFactory);
      final token = OAuth2Token(1000, 0, 'access', 'refresh');

      setUp(() {
        when(storage.getToken()).thenReturn(token);
      });

      group('when hasSession is called', () {
        var result;

        setUp(() async {
          result = await repository.hasSession();
        });

        test('it should return true', () {
          expect(result, isTrue);
        });
      });
    });

    group('given no stored token', () {
      final repository = SessionRepository(api, storage, requestFactory);

      setUp(() {
        when(storage.getToken()).thenReturn(null);
      });

      group('when hasSession is called', () {
        var result;

        setUp(() async {
          result = await repository.hasSession();
        });

        test('it should return false', () {
          expect(result, isFalse);
        });
      });
    });
  });
}
