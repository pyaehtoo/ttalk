import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  String phone, firstName, lastName, nickName;
  String? password;
  @JsonKey(name: "confirm_password")
  String? confirmPassword;
  @JsonKey(name: "birth_date")
  String birthDate;
  String? authToken;
  @JsonKey(name: 'user_id')
  int? userId;

  UserModel(
    this.phone,
    this.firstName,
    this.lastName,
    this.nickName,
    this.password,
    this.confirmPassword,
    this.birthDate,
    this.authToken,
    this.userId,
  );

  factory UserModel.fromJson(json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
