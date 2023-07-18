// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostRes _$CreatePostResFromJson(Map<String, dynamic> json) =>
    CreatePostRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null ? null : CreatePostData.fromJson(json['data']),
    );

Map<String, dynamic> _$CreatePostResToJson(CreatePostRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };

CreatePostData _$CreatePostDataFromJson(Map<String, dynamic> json) =>
    CreatePostData(
      json['id'] as int,
      json['postBy'] as int,
      json['content'] as String?,
      json['updatedAt'] as String?,
      json['privacy'] as String,
      json['feeling'] as String,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$CreatePostDataToJson(CreatePostData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postBy': instance.postBy,
      'content': instance.content,
      'updatedAt': instance.updatedAt,
      'privacy': instance.privacy,
      'feeling': instance.feeling,
      'createdAt': instance.createdAt,
    };
