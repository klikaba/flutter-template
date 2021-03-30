import 'package:json_annotation/json_annotation.dart';

import '../base/json.dart';
part 'model.g.dart';

@JsonSerializable(nullable: false)
class Credentials extends JsonEncodable {
  final String username;
  final String password;

  Credentials(this.username, this.password);

  @override
  Map<String, dynamic> toJson() => _$CredentialsToJson(this);

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);
}
