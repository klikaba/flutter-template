import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:flutter_template/data/country/api.dart';
import 'package:flutter_template/data/country/model.dart';

class MockBox extends Mock implements Box<Country> {}

class MockCountriesApi extends Mock implements CountriesApi {}

void main() {
  group('CountriesApi', () {
    final dioAdapter = DioAdapter();
    final dio = Dio();
    dio.httpClientAdapter = dioAdapter;
    final api = CountriesApi(dio);

    group('given working API', () {
      final response = {
        'countries': [
          {'code': 'BA', 'name': 'Bosnia & Herzegovina'},
          {'code': 'US', 'name': 'USA'}
        ]
      };

      setUp(() {
        dioAdapter.onGet('api/v1/countries').reply(200, response);
      });

      test('getAll should return countries', () async {
        final result = await api.getAll();

        expect(result, hasLength(2));
        expect(
            result,
            containsAll([
              predicate(
                  (c) => c.code == 'BA' && c.name == 'Bosnia & Herzegovina'),
              predicate((c) => c.code == 'US' && c.name == 'USA')
            ]));
      });
    });

    group('given failing API', () {
      setUp(() {
        dioAdapter.onPost('api/v1/countries').reply(400, 'error');
      });

      test('getAll should fail', () async {
        expect(api.getAll(), throwsException);
      });
    });
  });

  group('CountriesRepository', () {
    group('given empty cache', () {
      final box = MockBox();

      setUp(() {
        when(box.toMap()).thenReturn({});
      });

      tearDown(() {
        reset(box);
      });

      group('and working API', () {
        final api = MockCountriesApi();
        final repository = CountriesRepository(api, box);
        final countries = [
          Country('BA', 'Bosnia & Herzegovina'),
          Country('US', 'USA')
        ];

        setUp(() {
          when(api.getAll()).thenAnswer((_) => Future.value(countries));
        });

        group('when getAll is called', () {
          var result;

          setUp(() async {
            result = await repository.getAll();
          });

          test('it should return countries', () async {
            await expectLater(
                result, emitsInOrder([isEmpty, containsAll(countries)]));
            verify(api.getAll());
          });

          test('it should store countries', () {
            verify(box.putAll(any));
          });
        });
      });

      group('and failing API', () {
        final api = MockCountriesApi();
        final repository = CountriesRepository(api, box);

        setUp(() {
          when(api.getAll()).thenThrow(Exception());
        });

        group('when getAll is called', () {
          var result;

          setUp(() {
            result = repository.getAll();
          });

          test('it should return error', () async {
            try {
              await expectLater(
                  result, emitsInOrder([isEmpty, throwsException]));
            } catch (_) {}
            verify(api.getAll());
          });

          test('it should not change cache', () async {
            verify(box.toMap());
            verifyNoMoreInteractions(box);
          });
        });
      });
    });

    group('given stored countries in cache', () {
      final box = MockBox();
      final country = Country('BA', 'Bosnia & Herzegovina');

      setUp(() {
        when(box.toMap()).thenReturn({'BA': country});
      });

      tearDown(() {
        reset(box);
      });

      group('and working API', () {
        final api = MockCountriesApi();
        final repository = CountriesRepository(api, box);
        final newCountries = [
          Country('BA', 'Bosnia & Herzegovina'),
          Country('US', 'USA')
        ];

        setUp(() {
          when(api.getAll()).thenAnswer((_) => Future.value(newCountries));
        });

        group('when getAll is called', () {
          var result;

          setUp(() {
            result = repository.getAll();
          });

          test('it should return countries', () async {
            await expectLater(
                result,
                emitsInOrder([
                  [country],
                  newCountries
                ]));
            verify(api.getAll());
          });

          test('it should ask for countries in cache', () {
            verify(box.toMap());
          });

          test('it should store new countries', () {
            verify(box.putAll(any));
          });
        });
      });

      group('and failing API', () {
        final api = MockCountriesApi();
        final repository = CountriesRepository(api, box);

        setUp(() {
          when(api.getAll()).thenThrow(Exception());
        });

        group('when getAll is called', () {
          var result;

          setUp(() {
            result = repository.getAll();
          });

          test('it should return error', () async {
            try {
              await expectLater(
                  result,
                  emitsInOrder([
                    [country],
                    throwsException
                  ]));
            } catch (_) {}

            verify(api.getAll());
          });

          test('it should ask for countries in cache', () {
            verify(box.toMap());
          });

          test('it should not change cache', () {
            verify(box.toMap());
            verifyNoMoreInteractions(box);
          });
        });
      });
    });
  });
}
