// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['phone'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['nickName'] as String,
      json['password'] as String?,
      json['confirm_password'] as String?,
      json['birth_date'] as String,
      json['authToken'] as String?,
      json['user_id'] as int?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'phone': instance.phone,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'nickName': instance.nickName,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
      'birth_date': instance.birthDate,
      'authToken': instance.authToken,
      'user_id': instance.userId,
    };
