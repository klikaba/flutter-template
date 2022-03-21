import 'package:flutter_template/data/base/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Credentials extends JsonEncodable {
  final String username;
  final String password;

  Credentials(this.username, this.password);

  @override
  Map<String, dynamic> toJson() => _$CredentialsToJson(this);

  factory Credentials.fromJson(Map<String, dynamic> json) => _$CredentialsFromJson(json);
}
