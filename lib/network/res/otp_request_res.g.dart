// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestRes _$OtpRequestResFromJson(Map<String, dynamic> json) =>
    OtpRequestRes(
      json['status'] as bool?,
      json['otp'] as String?,
      json['phone'] as String?,
      json['client_ref'] as String?,
      json['message'] as String?,
    );

Map<String, dynamic> _$OtpRequestResToJson(OtpRequestRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'otp': instance.otp,
      'phone': instance.phone,
      'client_ref': instance.clientRef,
      'message': instance.message,
    };
