// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OAuth2TokenAdapter extends TypeAdapter<OAuth2Token> {
  @override
  final int typeId = 1;

  @override
  OAuth2Token read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OAuth2Token(
      fields[0] as int,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OAuth2Token obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.expiresIn)
      ..writeByte(2)
      ..write(obj.accessToken)
      ..writeByte(3)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OAuth2TokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2Token _$OAuth2TokenFromJson(Map<String, dynamic> json) => OAuth2Token(
      json['expiresIn'] as int,
      json['accessToken'] as String,
      json['refreshToken'] as String,
    );

Map<String, dynamic> _$OAuth2TokenToJson(OAuth2Token instance) =>
    <String, dynamic>{
      'expiresIn': instance.expiresIn,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
