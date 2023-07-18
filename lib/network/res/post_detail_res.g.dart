// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetailRes _$PostDetailResFromJson(Map<String, dynamic> json) =>
    PostDetailRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null ? null : PostModel.fromJson(json['data']),
    );

Map<String, dynamic> _$PostDetailResToJson(PostDetailRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };
