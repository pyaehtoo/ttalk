// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationRes _$NotificationResFromJson(Map<String, dynamic> json) =>
    NotificationRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null
          ? null
          : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationResToJson(NotificationRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      json['unreadCount'] as int,
      (json['notifications'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'unreadCount': instance.unreadCount,
      'notifications': instance.notifications?.map((e) => e.toJson()).toList(),
    };

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      json['id'] as int,
      json['notiableType'] as String,
      json['notiableId'] as int?,
      json['sourceId'] as int?,
      json['targetId'] as int?,
      json['isRead'] as int?,
      json['title'] as String,
      json['message'] as String,
      json['createdAt'] as String,
      json['SourceUser'] == null
          ? null
          : SourceUser.fromJson(json['SourceUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notiableType': instance.notiableType,
      'notiableId': instance.notiableId,
      'sourceId': instance.sourceId,
      'targetId': instance.targetId,
      'isRead': instance.isRead,
      'title': instance.title,
      'message': instance.message,
      'createdAt': instance.createdAt,
      'SourceUser': instance.sourceUser?.toJson(),
    };

SourceUser _$SourceUserFromJson(Map<String, dynamic> json) => SourceUser(
      json['id'] as int,
      json['nickName'] as String,
      json['Profile'] == null ? null : ProfileModel.fromJson(json['Profile']),
    );

Map<String, dynamic> _$SourceUserToJson(SourceUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'Profile': instance.profile?.toJson(),
    };
