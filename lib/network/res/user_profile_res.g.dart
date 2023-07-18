// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileRes _$UserProfileResFromJson(Map<String, dynamic> json) =>
    UserProfileRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['other'] as String?,
      json['data'] == null ? null : UserProfileModel.fromJson(json['data']),
    );

Map<String, dynamic> _$UserProfileResToJson(UserProfileRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'other': instance.other,
      'data': instance.data,
    };
