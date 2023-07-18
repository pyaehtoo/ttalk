// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuddyListRes _$BuddyListResFromJson(Map<String, dynamic> json) => BuddyListRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => BuddyListData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$BuddyListResToJson(BuddyListRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

BuddyListData _$BuddyListDataFromJson(Map<String, dynamic> json) =>
    BuddyListData(
      json['friendshipSince'] as String,
      json['friendId'] as int,
      json['nickName'] as String?,
      json['bio'] as String?,
      json['profileImageUrl'] as String?,
      json['coverImageUrl'] as String?,
    );

Map<String, dynamic> _$BuddyListDataToJson(BuddyListData instance) =>
    <String, dynamic>{
      'friendshipSince': instance.friendshipSince,
      'friendId': instance.friendId,
      'nickName': instance.nickName,
      'bio': instance.bio,
      'profileImageUrl': instance.profileImageUrl,
      'coverImageUrl': instance.coverImageUrl,
    };
