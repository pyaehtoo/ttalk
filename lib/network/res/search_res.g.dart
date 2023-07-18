// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRes _$SearchResFromJson(Map<String, dynamic> json) => SearchRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null
          ? null
          : SearchResData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchResToJson(SearchRes instance) => <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data,
    };

SearchResData _$SearchResDataFromJson(Map<String, dynamic> json) =>
    SearchResData(
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => AccountData.fromJson(e as Map<String, dynamic>))
          .toList(),
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => PostModel.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$SearchResDataToJson(SearchResData instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'posts': instance.posts,
    };

AccountData _$AccountDataFromJson(Map<String, dynamic> json) => AccountData(
      id: json['id'] as int?,
      nickName: json['nickName'] as String?,
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile']),
      relationshipStatus: json['relationshipStatus'] as String?,
      countFriends: json['countFriends'] as int?,
    );

Map<String, dynamic> _$AccountDataToJson(AccountData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'profile': instance.profile,
      'relationshipStatus': instance.relationshipStatus,
      'countFriends': instance.countFriends,
    };
