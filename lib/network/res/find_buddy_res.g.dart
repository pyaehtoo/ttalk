// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_buddy_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindBuddyRes _$FindBuddyResFromJson(Map<String, dynamic> json) => FindBuddyRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => FindBuddyData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$FindBuddyResToJson(FindBuddyRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

FindBuddyData _$FindBuddyDataFromJson(Map<String, dynamic> json) =>
    FindBuddyData(
      json['id'] as int,
      json['nickName'] as String?,
      json['relationshipStatus'] as String?,
      json['countFriends'] as int,
      json['Profile'] == null ? null : ProfileModel.fromJson(json['Profile']),
    );

Map<String, dynamic> _$FindBuddyDataToJson(FindBuddyData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'relationshipStatus': instance.relationshipStatus,
      'countFriends': instance.countFriends,
      'Profile': instance.profile?.toJson(),
    };
