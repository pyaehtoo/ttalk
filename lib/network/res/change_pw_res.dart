import 'package:json_annotation/json_annotation.dart';

part 'change_pw_res.g.dart';

@JsonSerializable(explicitToJson: true)
class ChangePwRes {
  bool? status;
  String? msg;

  ChangePwRes(this.status, this.msg);

  factory ChangePwRes.fromJson(Map<String, dynamic> json) =>
      _$ChangePwResFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePwResToJson(this);
}
