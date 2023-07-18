import 'package:json_annotation/json_annotation.dart';

part 'login_res.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginRes {
  bool? status;
  String? msg;
  LoginResData? data;

  LoginRes(this.status, this.msg, this.data);

  factory LoginRes.fromJson(Map<String, dynamic> json) =>
      _$LoginResFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LoginResData {
  @JsonKey(name: 'user_id')
  int? userId;
  String? phone, firstName, lastName, nickName, accessToken, profileImageUrl;
  List<LoginResCookie>? cookies;

  LoginResData(this.userId, this.phone, this.firstName, this.lastName,
      this.nickName, this.accessToken, this.profileImageUrl, this.cookies);

  factory LoginResData.fromJson(Map<String, dynamic> json) =>
      _$LoginResDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResDataToJson(this);
}

@JsonSerializable()
class LoginResCookie {
  String? key, value, domain, expires;

  LoginResCookie(this.key, this.value, this.domain, this.expires);

  factory LoginResCookie.fromJson(Map<String, dynamic> json) =>
      _$LoginResCookieFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResCookieToJson(this);
}
