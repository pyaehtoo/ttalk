// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_reacts_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReactsRes _$PostReactsResFromJson(Map<String, dynamic> json) =>
    PostReactsRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => PostReactData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$PostReactsResToJson(PostReactsRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

PostReactData _$PostReactDataFromJson(Map<String, dynamic> json) =>
    PostReactData(
      json['id'] as int,
      json['nickName'] as String?,
      json['profileImageUrl'] as String?,
      json['react'] as String,
    );

Map<String, dynamic> _$PostReactDataToJson(PostReactData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'profileImageUrl': instance.profileImageUrl,
      'react': instance.react,
    };
