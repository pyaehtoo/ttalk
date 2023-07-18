import 'package:json_annotation/json_annotation.dart';

part 'otp_request_res.g.dart';

@JsonSerializable(explicitToJson: true)
class OtpRequestRes {
  bool? status;
  String? otp, phone;
  @JsonKey(name: 'client_ref')
  String? clientRef;
  String? message;

  OtpRequestRes(this.status, this.otp, this.phone, this.clientRef, this.message);

  factory OtpRequestRes.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestResFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestResToJson(this);
}
