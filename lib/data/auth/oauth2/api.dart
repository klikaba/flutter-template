import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import 'token.dart';
import '../../base/json.dart';

part 'api.g.dart';

@JsonSerializable(nullable: false)
class CreateOAuth2TokenRequest extends JsonEncodable {
  final String username;
  final String password;
  final String clientId;
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
  final String refreshToken;
  final String clientId;
  final String clientSecret;

  RefreshOAuth2TokenRequest(
      {this.refreshToken, this.clientId, this.clientSecret});

  @override
  Map<String, dynamic> toJson() => _$RefreshOAuth2TokenRequestToJson(this);

  factory RefreshOAuth2TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshOAuth2TokenRequestFromJson(json);
}

class OAuth2TokenApi {
  final Dio _client;

  OAuth2TokenApi(this._client);

  Future<OAuth2Token> createToken(CreateOAuth2TokenRequest request) async {
    final response = await _client.post('oauth/token', data: request.toJson());
    return OAuth2Token.fromJson(convert.jsonDecode(response.data));
  }

  Future<OAuth2Token> refreshToken(RefreshOAuth2TokenRequest request) async {
    final response =
        await _client.post('oauth/refresh', data: request.toJson());
    return OAuth2Token.fromJson(convert.jsonDecode(response.data));
  }
}
