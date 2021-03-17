import 'package:dio/dio.dart';
import 'package:flutter_template/data/auth/config.dart';
import 'package:json_annotation/json_annotation.dart';

import 'token.dart';
import '../../base/json.dart';

part 'api.g.dart';

@JsonSerializable(nullable: false)
class CreateOAuth2TokenRequest extends JsonEncodable {
  final String username;
  final String password;
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'client_secret')
  final String clientSecret;

  CreateOAuth2TokenRequest(
      {this.username, this.password, this.clientId, this.clientSecret});

  @override
  Map<String, dynamic> toJson() => _$CreateOAuth2TokenRequestToJson(this);

  factory CreateOAuth2TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOAuth2TokenRequestFromJson(json);
}

@JsonSerializable(nullable: false)
class RefreshOAuth2TokenRequest extends JsonEncodable {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'client_secret')
  final String clientSecret;

  RefreshOAuth2TokenRequest(
      {this.refreshToken, this.clientId, this.clientSecret});

  @override
  Map<String, dynamic> toJson() => _$RefreshOAuth2TokenRequestToJson(this);

  factory RefreshOAuth2TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshOAuth2TokenRequestFromJson(json);
}

class OAuth2TokenRequestFactory {
  final ClientConfig _config;

  OAuth2TokenRequestFactory(this._config);

  RefreshOAuth2TokenRequest makeRefreshRequest(String refreshToken) {
    return RefreshOAuth2TokenRequest(
        refreshToken: refreshToken,
        clientId: _config.clientId,
        clientSecret: _config.clientSecret);
  }

  CreateOAuth2TokenRequest makeCreateRequest(String username, String password) {
    return CreateOAuth2TokenRequest(
        username: username,
        password: password,
        clientId: _config.clientId,
        clientSecret: _config.clientSecret);
  }
}

class OAuth2TokenApi {
  final Dio _client;

  OAuth2TokenApi(this._client);

  Future<OAuth2Token> createToken(CreateOAuth2TokenRequest request) async {
    final response = await _client.post('oauth/token',
        data: request.toJson(), queryParameters: {'grant_type': 'password'});
    return OAuth2Token.fromJson(response.data);
  }

  Future<OAuth2Token> refreshToken(RefreshOAuth2TokenRequest request) async {
    final response = await _client.post('oauth/token',
        data: request.toJson(),
        queryParameters: {'grant_type': 'refresh_token'});
    return OAuth2Token.fromJson(response.data);
  }
}
