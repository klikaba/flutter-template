import 'package:flutter/material.dart';
import 'package:flutter_template/data/auth/token.dart';
import 'package:flutter_template/data/base/json.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
@immutable
@HiveType(typeId: 1)
class OAuth2Token extends RefreshableToken with JsonEncodable {
  @HiveField(0)
  @JsonKey(name: 'expiresIn')
  final int expiresIn;
  @HiveField(2)
  @JsonKey(name: 'accessToken')
  final String accessToken;
  @HiveField(3)
  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  OAuth2Token(this.expiresIn, this.accessToken, this.refreshToken);

  @override
  String get refreshTokenString => refreshToken;

  @override
  String get tokenString => accessToken;

  @override
  bool isExpired() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return now < expiresIn;
  }

  @override
  Map<String, dynamic> toJson() => _$OAuth2TokenToJson(this);

  factory OAuth2Token.fromJson(Map<String, dynamic> json) => _$OAuth2TokenFromJson(json);
}

class OAuth2TokenStorage {
  final Box<OAuth2Token> _tokenBox;

  OAuth2TokenStorage(this._tokenBox);

  void saveToken(OAuth2Token token) {
    _tokenBox.put('oauth2token', token);
  }

  OAuth2Token? getToken() => _tokenBox.get('oauth2token');

  void clearToken() {
    _tokenBox.delete('oauth2token');
  }
}
