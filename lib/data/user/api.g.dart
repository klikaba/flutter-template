// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationInfo _$RegistrationInfoFromJson(Map<String, dynamic> json) {
  return RegistrationInfo(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$RegistrationInfoToJson(RegistrationInfo instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
