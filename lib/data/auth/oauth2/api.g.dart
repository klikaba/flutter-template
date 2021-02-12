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
    clientId: json['clientId'] as String,
    clientSecret: json['clientSecret'] as String,
  );
}

Map<String, dynamic> _$CreateOAuth2TokenRequestToJson(
        CreateOAuth2TokenRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
    };

RefreshOAuth2TokenRequest _$RefreshOAuth2TokenRequestFromJson(
    Map<String, dynamic> json) {
  return RefreshOAuth2TokenRequest(
    refreshToken: json['refreshToken'] as String,
    clientId: json['clientId'] as String,
    clientSecret: json['clientSecret'] as String,
  );
}

Map<String, dynamic> _$RefreshOAuth2TokenRequestToJson(
        RefreshOAuth2TokenRequest instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
    };
