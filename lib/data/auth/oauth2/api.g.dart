// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOAuth2TokenRequest _$CreateOAuth2TokenRequestFromJson(
        Map<String, dynamic> json) =>
    CreateOAuth2TokenRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      clientId: json['clientId'] as String,
      clientSecret: json['clientSecret'] as String,
      grantType: json['grantType'] as String? ?? '',
      scope: json['scope'] as String? ?? '',
    );

Map<String, dynamic> _$CreateOAuth2TokenRequestToJson(
        CreateOAuth2TokenRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'grantType': instance.grantType,
      'scope': instance.scope,
    };

RefreshOAuth2TokenRequest _$RefreshOAuth2TokenRequestFromJson(
        Map<String, dynamic> json) =>
    RefreshOAuth2TokenRequest(
      refreshToken: json['refresh_token'] as String,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
    );

Map<String, dynamic> _$RefreshOAuth2TokenRequestToJson(
        RefreshOAuth2TokenRequest instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
    };
