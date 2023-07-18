// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      json['birthDate'] as String?,
      json['bio'] as String?,
      json['gender'] as String?,
      json['profileImageUrl'] as String?,
      json['coverImageUrl'] as String?,
      json['maritalStatus'] as String?,
      json['phone'] as String?,
      json['name'] as String?,
      json['nickName'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      json['uniqueName'] as String?,
      json['imsAccountId'] as String?,
      json['city'] as int?,
      json['hometown'] as int?,
      json['accountId'] as int?,
      json['postCount'] as int?,
      json['friendCount'] as int?,
      json['relationship_status'] as String?,
    )..userId = json['userId'] as int?;

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'birthDate': instance.birthDate,
      'bio': instance.bio,
      'gender': instance.gender,
      'profileImageUrl': instance.profileImageUrl,
      'coverImageUrl': instance.coverImageUrl,
      'maritalStatus': instance.maritalStatus,
      'phone': instance.phone,
      'name': instance.name,
      'nickName': instance.nickName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'uniqueName': instance.uniqueName,
      'imsAccountId': instance.imsAccountId,
      'city': instance.city,
      'hometown': instance.hometown,
      'accountId': instance.accountId,
      'postCount': instance.postCount,
      'friendCount': instance.friendCount,
      'relationship_status': instance.relationshipStatus,
      'userId': instance.userId,
    };
