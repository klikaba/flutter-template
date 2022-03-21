import 'package:dio/dio.dart';
import 'package:flutter_template/data/auth/config.dart';
import 'package:flutter_template/data/auth/oauth2/token.dart';
import 'package:flutter_template/data/base/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api.g.dart';

@JsonSerializable()
class CreateOAuth2TokenRequest extends JsonEncodable {
  final String email;
  final String password;
  @JsonKey(name: 'clientId')
  final String clientId;
  @JsonKey(name: 'clientSecret')
  final String clientSecret;
  final String grantType;
  final String scope;

  CreateOAuth2TokenRequest(
      {required this.email, required this.password, required this.clientId, required this.clientSecret, this.grantType = '', this.scope = ''});

  @override
  Map<String, dynamic> toJson() => _$CreateOAuth2TokenRequestToJson(this);

  factory CreateOAuth2TokenRequest.fromJson(Map<String, dynamic> json) => _$CreateOAuth2TokenRequestFromJson(json);
}

@JsonSerializable()
class RefreshOAuth2TokenRequest extends JsonEncodable {
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'client_secret')
  final String clientSecret;

  RefreshOAuth2TokenRequest({required this.refreshToken, required this.clientId, required this.clientSecret});

  @override
  Map<String, dynamic> toJson() => _$RefreshOAuth2TokenRequestToJson(this);

  factory RefreshOAuth2TokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshOAuth2TokenRequestFromJson(json);
}

class OAuth2TokenRequestFactory {
  final ClientConfig _config;

  OAuth2TokenRequestFactory(this._config);

  RefreshOAuth2TokenRequest makeRefreshRequest(String refreshToken) {
    return RefreshOAuth2TokenRequest(refreshToken: refreshToken, clientId: _config.clientId, clientSecret: _config.clientSecret);
  }

  CreateOAuth2TokenRequest makeCreateRequest(String email, String password) {
    return CreateOAuth2TokenRequest(email: email, password: password, clientId: _config.clientId, clientSecret: _config.clientSecret);
  }
}

class OAuth2TokenApi {
  final Dio _client;

  OAuth2TokenApi(this._client);

  Future<OAuth2Token> createToken(CreateOAuth2TokenRequest request) async {
    final response = await _client.post('api/v1/Identity/token', data: request.toJson());
    return OAuth2Token.fromJson(response.data as Map<String, dynamic>);
  }

  Future<OAuth2Token> refreshToken(RefreshOAuth2TokenRequest request) async {
    final response = await _client.post('api/v1/Identity/token', data: request.toJson());
    return OAuth2Token.fromJson(response.data as Map<String, dynamic>);
  }
}
