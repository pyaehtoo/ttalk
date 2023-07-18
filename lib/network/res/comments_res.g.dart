// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsRes _$CommentsResFromJson(Map<String, dynamic> json) => CommentsRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CommentsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentsResToJson(CommentsRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

CommentsData _$CommentsDataFromJson(Map<String, dynamic> json) => CommentsData(
      json['id'] as int,
      json['comment'] as String?,
      json['parentId'] as int?,
      json['replyCount'] as int,
      json['reactCount'] as int,
      json['reactByMe'] as int,
      json['createdAt'] as String,
      PostByModel.fromJson(json['Commenter']),
    )..isViewAllComment = json['isViewAllComment'] as bool?;

Map<String, dynamic> _$CommentsDataToJson(CommentsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'parentId': instance.parentId,
      'replyCount': instance.replyCount,
      'reactCount': instance.reactCount,
      'reactByMe': instance.reactByMe,
      'createdAt': instance.createdAt,
      'isViewAllComment': instance.isViewAllComment,
      'Commenter': instance.commenter.toJson(),
    };
