import 'package:json_annotation/json_annotation.dart';

part 'otp_validation_res.g.dart';

@JsonSerializable(explicitToJson: true)
class OtpValidationRes {
  bool? status;
  String? msg;

  OtpValidationRes(this.status, this.msg);

  factory OtpValidationRes.fromJson(Map<String, dynamic> json) =>
      _$OtpValidationResFromJson(json);

  Map<String, dynamic> toJson() => _$OtpValidationResToJson(this);
}
