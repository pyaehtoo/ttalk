// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy_rec_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuddyRecListRes _$BuddyRecListResFromJson(Map<String, dynamic> json) =>
    BuddyRecListRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => BuddyRecListData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$BuddyRecListResToJson(BuddyRecListRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

BuddyRecListData _$BuddyRecListDataFromJson(Map<String, dynamic> json) =>
    BuddyRecListData(
      json['requestedSince'] as String,
      json['status'] as int,
      json['requesterId'] as int,
      json['Requester'] == null
          ? null
          : BuddyRequesterData.fromJson(json['Requester']),
    );

Map<String, dynamic> _$BuddyRecListDataToJson(BuddyRecListData instance) =>
    <String, dynamic>{
      'requestedSince': instance.requestedSince,
      'status': instance.status,
      'requesterId': instance.requesterId,
      'Requester': instance.requester?.toJson(),
    };

BuddyRequesterData _$BuddyRequesterDataFromJson(Map<String, dynamic> json) =>
    BuddyRequesterData(
      json['id'] as int,
      json['nickName'] as String?,
      ProfileModel.fromJson(json['Profile']),
    );

Map<String, dynamic> _$BuddyRequesterDataToJson(BuddyRequesterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'Profile': instance.profile.toJson(),
    };
