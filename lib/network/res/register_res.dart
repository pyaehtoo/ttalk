import 'package:json_annotation/json_annotation.dart';

part 'register_res.g.dart';

@JsonSerializable(explicitToJson: true)
class RegisterRes {
  bool? status;
  String? msg;
  RegisterResData? data;

  RegisterRes(this.status, this.msg, this.data);

  factory RegisterRes.fromJson(Map<String, dynamic> json) =>
      _$RegisterResFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResToJson(this);
}

@JsonSerializable()
class RegisterResData {
  String authToken;
  @JsonKey(name: 'user_id')
  int userId;

  RegisterResData(this.authToken, this.userId);

  factory RegisterResData.fromJson(Map<String, dynamic> json) =>
      _$RegisterResDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResDataToJson(this);
}
