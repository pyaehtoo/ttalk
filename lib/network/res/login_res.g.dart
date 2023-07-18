// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRes _$LoginResFromJson(Map<String, dynamic> json) => LoginRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null
          ? null
          : LoginResData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResToJson(LoginRes instance) => <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };

LoginResData _$LoginResDataFromJson(Map<String, dynamic> json) => LoginResData(
      json['user_id'] as int?,
      json['phone'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['nickName'] as String?,
      json['accessToken'] as String?,
      json['profileImageUrl'] as String?,
      (json['cookies'] as List<dynamic>?)
          ?.map((e) => LoginResCookie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoginResDataToJson(LoginResData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'phone': instance.phone,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nickName': instance.nickName,
      'accessToken': instance.accessToken,
      'profileImageUrl': instance.profileImageUrl,
      'cookies': instance.cookies?.map((e) => e.toJson()).toList(),
    };

LoginResCookie _$LoginResCookieFromJson(Map<String, dynamic> json) =>
    LoginResCookie(
      json['key'] as String?,
      json['value'] as String?,
      json['domain'] as String?,
      json['expires'] as String?,
    );

Map<String, dynamic> _$LoginResCookieToJson(LoginResCookie instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'domain': instance.domain,
      'expires': instance.expires,
    };
