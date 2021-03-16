import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:flutter_template/data/user/api.dart';
import 'package:flutter_template/data/user/model.dart';

class MockBox extends Mock implements Box<User> {}

class MockUserApi extends Mock implements UserApi {}

void main() {
  group('UserApi', () {
    final dioAdapter = DioAdapter();
    final dio = Dio();
    dio.httpClientAdapter = dioAdapter;
    final api = UserApi(dio);

    group('given working API', () {
      final response = {
        'id': 1,
        'email': 'test',
        'createdAt': 'date',
        'updatedAt': 'date',
        'role': 'user'
      };

      final registrationRequest =
          RegistrationInfo(email: 'test', password: 'test');
      setUp(() {
        // Waiting for https://github.com/lomsa-dev/http-mock-adapter/pull/84
        dioAdapter
            .onPost('api/v1/users',
                data: {'user': registrationRequest.toJson()})
            .reply(200, response)
            .onGet('api/v1/users/1')
            .reply(200, response);
      });

      test('create should return User', () async {
        final result = await api.create(registrationRequest);

        expect(result.id, equals(1));
        expect(result.email, equals('test'));
        expect(result.createdAt, equals('date'));
        expect(result.updatedAt, equals('date'));
        expect(result.role, equals('user'));
      });

      test('get should return User', () async {
        final result = await api.get(1);

        expect(result.id, equals(1));
        expect(result.email, equals('test'));
        expect(result.createdAt, equals('date'));
        expect(result.updatedAt, equals('date'));
        expect(result.role, equals('user'));
      });
    });

    group('given failing API', () {
      setUp(() {
        dioAdapter
            .onPost('api/v1/users')
            .reply(400, 'error')
            .onGet('api/v1/users/1')
            .reply(400, 'error');
      });

      test('create should fail', () async {
        expect(api.create(RegistrationInfo(email: 'test', password: 'test')),
            throwsException);
      });

      test('get should fail', () async {
        expect(api.get(1), throwsException);
      });
    });
  });

  group('UserRepository', () {
    group('given empty cache', () {
      final box = MockBox();

      tearDown(() {
        reset(box);
      });

      group('and working API', () {
        final api = MockUserApi();
        final repository = UserRepository(api, box);
        final user = User(1, 'test', 'test', 'test', 'test');

        setUp(() {
          when(api.create(any)).thenAnswer((_) => Future.value(user));
          when(api.get(any)).thenAnswer((_) => Future.value(user));
        });

        group('when create is called', () {
          var result;
          final request = RegistrationInfo(email: 'test', password: 'test');

          setUp(() async {
            result = await repository.create(request);
          });

          test('it should return User', () {
            expect(result, equals(user));
            verify(api.create(request));
          });

          test('it should store User', () {
            verify(box.put('1', user));
          });
        });

        group('when get is called', () {
          var result;

          setUp(() {
            result = repository.get(1);
          });

          test('it should return User', () async {
            await expectLater(result, emitsInOrder([null, user]));
            verify(api.get(1));
          });

          test('it should ask for User in cache', () {
            verify(box.get('1'));
          });

          test('it should store User', () {
            verify(box.put('1', user));
          });
        });
      });

      group('and failing API', () {
        final api = MockUserApi();
        final repository = UserRepository(api, box);

        setUp(() {
          when(api.create(any)).thenThrow(Exception());
          when(api.get(any)).thenThrow(Exception());
        });

        group('when create is called', () {
          final request = RegistrationInfo(email: 'test', password: 'test');

          test('it should return error', () async {
            expect(repository.create(request), throwsException);
            verify(api.create(request));
          });

          test('it should not change cache', () {
            expect(repository.create(request), throwsException);
            verifyNoMoreInteractions(box);
          });
        });

        group('when get is called', () {
          var result;

          setUp(() {
            result = repository.get(1);
          });

          test('it should return error', () async {
            try {
              await expectLater(result, emitsInOrder([null, throwsException]));
            } catch (_) {}

            verify(api.get(1));
          });

          test('it should ask for User in cache', () {
            verify(box.get('1'));
          });

          test('it should not change cache', () {
            verify(box.get('1'));
            verifyNoMoreInteractions(box);
          });
        });
      });
    });

    group('given stored User in cache', () {
      final box = MockBox();
      final user = User(1, 'test', 'test', 'test', 'test');

      setUp(() {
        when(box.get('1')).thenReturn(user);
      });

      tearDown(() {
        reset(box);
      });

      group('and working API', () {
        final api = MockUserApi();
        final repository = UserRepository(api, box);
        final newUser = User(1, 'test2', 'test2', 'test2', 'test2');

        setUp(() {
          when(api.create(any)).thenAnswer((_) => Future.value(newUser));
          when(api.get(any)).thenAnswer((_) => Future.value(newUser));
        });

        group('when get is called', () {
          var result;

          setUp(() {
            result = repository.get(1);
          });

          test('it should return User', () async {
            await expectLater(result, emitsInOrder([user, newUser]));
            verify(api.get(1));
          });

          test('it should ask for User in cache', () {
            verify(box.get('1'));
          });

          test('it should store User', () {
            verify(box.put('1', newUser));
          });
        });
      });

      group('and failing API', () {
        final api = MockUserApi();
        final repository = UserRepository(api, box);

        setUp(() {
          when(api.create(any)).thenThrow(Exception());
          when(api.get(any)).thenThrow(Exception());
        });

        group('when get is called', () {
          var result;

          setUp(() {
            result = repository.get(1);
          });

          test('it should return error', () async {
            try {
              await expectLater(result, emitsInOrder([user, throwsException]));
            } catch (_) {}

            verify(api.get(1));
          });

          test('it should ask for User in cache', () {
            verify(box.get('1'));
          });

          test('it should not change cache', () {
            verify(box.get('1'));
            verifyNoMoreInteractions(box);
          });
        });
      });
    });
  });
}
