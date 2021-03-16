import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'dart:io';

import '../base/json.dart';
import 'model.dart';

part 'api.g.dart';

@JsonSerializable(nullable: false)
class RegistrationInfo extends JsonEncodable {
  final String email;
  final String password;

  RegistrationInfo({this.email, this.password});

  @override
  Map<String, dynamic> toJson() => _$RegistrationInfoToJson(this);

  factory RegistrationInfo.fromJson(Map<String, dynamic> json) =>
      _$RegistrationInfoFromJson(json);
}

class UserApi {
  final Dio _client;

  UserApi(this._client);

  Future<User> create(RegistrationInfo request) async {
    final response =
        await _client.post('api/v1/users', data: {'user': request.toJson()});
    return User.fromJson(response.data);
  }

  Future<User> get(int id) async {
    final response = await _client.get('api/v1/users/$id');
    return User.fromJson(response.data);
  }
}

class UserRepository {
  final UserApi _api;
  final Box<User> _usersBox;

  UserRepository(this._api, this._usersBox);

  Future<User> create(RegistrationInfo request) async {
    final user = await _api.create(request);
    await _usersBox.put('${user.id}', user);
    return user;
  }

  Stream<User> get(int id) {
    Future<User> loadUser() async {
      final user = await _api.get(id);
      stdout.writeln('$user');
      await _usersBox.put('${user.id}', user);
      return user;
    }

    // Combine cached data with fresh API data
    return Stream.fromFutures(
        [Future.value(_usersBox.get('${id}')), loadUser()]);
  }
}
