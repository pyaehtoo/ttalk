// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRes _$PostResFromJson(Map<String, dynamic> json) => PostRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => PostModel.fromJson(e))
          .toList(),
      json['count'] as int?,
    );

Map<String, dynamic> _$PostResToJson(PostRes instance) => <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'count': instance.count,
    };
