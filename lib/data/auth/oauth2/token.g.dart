// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2Token _$OAuth2TokenFromJson(Map<String, dynamic> json) {
  return OAuth2Token(
    json['expirationPeriod'] as int,
    json['createdAt'] as int,
    json['accessToken'] as String,
    json['refreshToken'] as String,
  );
}

Map<String, dynamic> _$OAuth2TokenToJson(OAuth2Token instance) =>
    <String, dynamic>{
      'expirationPeriod': instance.expirationPeriod,
      'createdAt': instance.createdAt,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
