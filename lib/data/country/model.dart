import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

import '../base/json.dart';
part 'model.g.dart';

@JsonSerializable(nullable: false)
@immutable
@HiveType(typeId: 3)
class Country extends JsonEncodable {
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String name;

  Country(this.code, this.name);

  @override
  Map<String, dynamic> toJson() => _$CountryToJson(this);

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
}
