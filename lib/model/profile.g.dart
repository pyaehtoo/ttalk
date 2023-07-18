// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      json['id'] as int?,
      json['nickName'] as String?,
      json['bio'] as String?,
      json['profileImageUrl'] as String?,
      json['coverImageUrl'] as String?,
      json['userId'] as int?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'nickName': instance.nickName,
      'bio': instance.bio,
      'profileImageUrl': instance.profileImageUrl,
      'coverImageUrl': instance.coverImageUrl,
    };
