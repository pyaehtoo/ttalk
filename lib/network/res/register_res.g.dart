// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRes _$RegisterResFromJson(Map<String, dynamic> json) => RegisterRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null
          ? null
          : RegisterResData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterResToJson(RegisterRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };

RegisterResData _$RegisterResDataFromJson(Map<String, dynamic> json) =>
    RegisterResData(
      json['authToken'] as String,
      json['user_id'] as int,
    );

Map<String, dynamic> _$RegisterResDataToJson(RegisterResData instance) =>
    <String, dynamic>{
      'authToken': instance.authToken,
      'user_id': instance.userId,
    };
