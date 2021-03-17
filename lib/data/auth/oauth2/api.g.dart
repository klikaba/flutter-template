// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOAuth2TokenRequest _$CreateOAuth2TokenRequestFromJson(
    Map<String, dynamic> json) {
  return CreateOAuth2TokenRequest(
    username: json['username'] as String,
    password: json['password'] as String,
    clientId: json['client_id'] as String,
    clientSecret: json['client_secret'] as String,
  );
}

Map<String, dynamic> _$CreateOAuth2TokenRequestToJson(
        CreateOAuth2TokenRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
    };

RefreshOAuth2TokenRequest _$RefreshOAuth2TokenRequestFromJson(
    Map<String, dynamic> json) {
  return RefreshOAuth2TokenRequest(
    refreshToken: json['refresh_token'] as String,
    clientId: json['client_id'] as String,
    clientSecret: json['client_secret'] as String,
  );
}

Map<String, dynamic> _$RefreshOAuth2TokenRequestToJson(
        RefreshOAuth2TokenRequest instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
    };
