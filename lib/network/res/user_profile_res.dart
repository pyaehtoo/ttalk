import 'package:json_annotation/json_annotation.dart';

import '../../model/user_profile.dart';

part 'user_profile_res.g.dart';

@JsonSerializable()
class UserProfileRes {
  bool? status;
  String? msg, other;
  UserProfileModel? data;

  UserProfileRes(this.status, this.msg, this.other, this.data);

  factory UserProfileRes.fromJson(json) => _$UserProfileResFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResToJson(this);
}
