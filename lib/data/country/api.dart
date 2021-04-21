import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'model.dart';

class CountriesApi {
  final Dio _client;

  CountriesApi(this._client);

  Future<Iterable<Country>> getAll() async {
    final response = await _client.get('api/v1/countries');
    return (response.data['countries'] as List)
        .map((country) => Country.fromJson(country));
  }
}

class CountriesRepository {
  final CountriesApi _api;
  final Box<Country> _countriesBox;

  CountriesRepository(this._api, this._countriesBox);

  Stream<Iterable<Country>> getAll() {
    Future<Iterable<Country>> loadContries() async {
      final countries = await _api.getAll();
      await _countriesBox.putAll({for (var c in countries) c.code: c});
      return countries;
    }

    return Stream.fromFutures(
        [Future.value(_countriesBox.toMap().values), loadContries()]);
  }
}
