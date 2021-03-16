import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_template/data/auth/oauth2/token.dart';

class MockBox extends Mock implements Box<OAuth2Token> {}

void main() {
  group('OAuth2Token', () {
    group('given fresh token', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      final token = OAuth2Token(1000, now, 'access', 'refresh');
      test('it should not be expired', () {
        expect(token.isExpired(), equals(true));
      });
    });

    group('given old token', () {
      final now = DateTime.now().millisecondsSinceEpoch - 10000;
      final token = OAuth2Token(1000, now, 'access', 'refresh');
      test('it should be expired', () {
        expect(token.isExpired(), equals(false));
      });
    });
  });

  group('OAuth2TokenStorage', () {
    final box = MockBox();
    final storage = OAuth2TokenStorage(box);

    tearDown(() {
      reset(box);
    });

    group('given empty box', () {
      group('when getToken is called', () {
        var result;
        setUp(() {
          result = storage.getToken();
        });

        test('it should return null', () {
          expect(result, equals(null));
          verify(box.get('oauth2token'));
        });

        test('it should not modify box', () {
          verify(box.get(any));
          verifyNoMoreInteractions(box);
        });
      });
    });

    group('given box with stored token', () {
      group('when getToken is called', () {
        var result;
        final storedToken = OAuth2Token(1000, 1001, 'test', 'test2');
        setUp(() {
          reset(box);
          when(box.get('oauth2token')).thenReturn(storedToken);
          result = storage.getToken();
        });

        test('it should return stored token', () {
          expect(result, equals(storedToken));
          verify(box.get('oauth2token'));
        });

        test('it should not modify box', () {
          verify(box.get(any));
          verifyNoMoreInteractions(box);
        });
      });
    });

    group('when clearToken is called', () {
      setUp(() {
        storage.clearToken();
      });

      test('it should delete token from box', () {
        verify(box.delete('oauth2token'));
      });

      test('it should not delete anything else', () {
        verify(box.delete('oauth2token'));
        verifyNoMoreInteractions(box);
      });
    });

    group('when saveToken is called', () {
      final tokenToStore = OAuth2Token(1001, 1002, 'test2', 'test3');
      setUp(() {
        storage.saveToken(tokenToStore);
      });

      test('it should put token in the box', () {
        verify(box.put('oauth2token', tokenToStore));
      });

      test('it should not modify anything else', () {
        verify(box.put('oauth2token', tokenToStore));
        verifyNoMoreInteractions(box);
      });
    });
  });
}
