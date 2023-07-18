import 'package:json_annotation/json_annotation.dart';

part 'reset_pw_res.g.dart';

@JsonSerializable(explicitToJson: true)
class ResetPwRes {
  bool? status;
  String? msg;

  ResetPwRes(this.status, this.msg);

  factory ResetPwRes.fromJson(Map<String, dynamic> json) =>
      _$ResetPwResFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPwResToJson(this);
}
