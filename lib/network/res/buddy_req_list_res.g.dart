// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy_req_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuddyReqListRes _$BuddyReqListResFromJson(Map<String, dynamic> json) =>
    BuddyReqListRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => BuddyReqListData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$BuddyReqListResToJson(BuddyReqListRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

BuddyReqListData _$BuddyReqListDataFromJson(Map<String, dynamic> json) =>
    BuddyReqListData(
      json['requestedSince'] as String,
      json['status'] as int,
      json['recipientId'] as int,
      json['Recipient'] == null
          ? null
          : BuddyRecipientData.fromJson(json['Recipient']),
    );

Map<String, dynamic> _$BuddyReqListDataToJson(BuddyReqListData instance) =>
    <String, dynamic>{
      'requestedSince': instance.requestedSince,
      'status': instance.status,
      'recipientId': instance.recipientId,
      'Recipient': instance.recipient?.toJson(),
    };

BuddyRecipientData _$BuddyRecipientDataFromJson(Map<String, dynamic> json) =>
    BuddyRecipientData(
      json['id'] as int,
      json['nickName'] as String?,
      ProfileModel.fromJson(json['Profile']),
    );

Map<String, dynamic> _$BuddyRecipientDataToJson(BuddyRecipientData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'Profile': instance.profile.toJson(),
    };
