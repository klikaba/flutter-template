import 'package:flutter/material.dart';
import '../../base/json.dart';
import 'package:json_annotation/json_annotation.dart';
import '../token.dart';

part 'token.g.dart';

@JsonSerializable(nullable: false)
@immutable
class OAuth2Token extends RefreshableToken with JsonEncodable {
  final int expirationPeriod;
  final int createdAt;
  final String accessToken;
  final String refreshToken;

  OAuth2Token(this.expirationPeriod, this.createdAt, this.accessToken,
      this.refreshToken);

  @override
  String get refreshTokenString => refreshToken;

  @override
  String get tokenString => accessToken;

  @override
  bool expired() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() => _$OAuth2TokenToJson(this);

  factory OAuth2Token.fromJson(Map<String, dynamic> json) =>
      _$OAuth2TokenFromJson(json);
}
