import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

import '../base/json.dart';
part 'model.g.dart';

@JsonSerializable(nullable: false)
@immutable
@HiveType(typeId: 2)
class User extends JsonEncodable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String createdAt;
  @HiveField(3)
  final String updatedAt;
  @HiveField(4)
  final String role;

  User(this.id, this.email, this.createdAt, this.updatedAt, this.role);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
