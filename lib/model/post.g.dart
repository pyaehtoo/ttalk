// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      json['id'] as int,
      json['postBy'] as int,
      json['commentCount'] as int,
      json['reactCount'] as int,
      json['reactByMe'] as int,
      json['stickerCount'] as int?,
      json['shareCount'] as int?,
      json['parentId'] as int?,
      json['content'] as String?,
      json['feeling'] as String?,
      json['privacy'] as String?,
      json['createdAt'] as String?,
      json['PostBy'] == null ? null : PostByModel.fromJson(json['PostBy']),
      (json['PostImages'] as List<dynamic>?)
          ?.map((e) => PostImageModel.fromJson(e))
          .toList(),
      (json['Reacts'] as List<dynamic>?)
          ?.map((e) => PostReactModel.fromJson(e))
          .toList(),
      json['Share'] == null ? null : PostShareModel.fromJson(json['Share']),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'postBy': instance.postBy,
      'commentCount': instance.commentCount,
      'reactCount': instance.reactCount,
      'reactByMe': instance.reactByMe,
      'shareCount': instance.shareCount,
      'stickerCount': instance.stickerCount,
      'parentId': instance.parentId,
      'content': instance.content,
      'feeling': instance.feeling,
      'privacy': instance.privacy,
      'createdAt': instance.createdAt,
      'PostBy': instance.postByData?.toJson(),
      'PostImages': instance.postImages?.map((e) => e.toJson()).toList(),
      'Reacts': instance.reacts?.map((e) => e.toJson()).toList(),
      'Share': instance.share?.toJson(),
    };

PostByModel _$PostByModelFromJson(Map<String, dynamic> json) => PostByModel(
      json['id'] as int,
      json['nickName'] as String?,
      json['Profile'] == null ? null : ProfileModel.fromJson(json['Profile']),
    );

Map<String, dynamic> _$PostByModelToJson(PostByModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickName': instance.nickName,
      'Profile': instance.profile?.toJson(),
    };

PostImageModel _$PostImageModelFromJson(Map<String, dynamic> json) =>
    PostImageModel(
      json['id'] as int,
      json['filePath'] as String?,
      json['mediableType'] as String?,
    );

Map<String, dynamic> _$PostImageModelToJson(PostImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filePath': instance.filePath,
      'mediableType': instance.mediableType,
    };

PostReactModel _$PostReactModelFromJson(Map<String, dynamic> json) =>
    PostReactModel(
      json['id'] as int,
      json['reactableType'] as String,
      json['reactableId'] as int,
      json['reacterId'] as int,
      json['react'] as String,
      json['createdAt'] as String,
      json['updatedAt'] as String,
      json['Reacter'] == null ? null : ProfileModel.fromJson(json['Reacter']),
    );

Map<String, dynamic> _$PostReactModelToJson(PostReactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reactableType': instance.reactableType,
      'reactableId': instance.reactableId,
      'reacterId': instance.reacterId,
      'react': instance.react,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'Reacter': instance.reacter?.toJson(),
    };

PostShareModel _$PostShareModelFromJson(Map<String, dynamic> json) =>
    PostShareModel(
      json['id'] as int,
      json['postBy'] as int,
      json['content'] as String?,
      json['feeling'] as String?,
      json['privacy'] as String?,
      json['createdAt'] as String?,
      json['PostBy'] == null ? null : PostByModel.fromJson(json['PostBy']),
      (json['PostImages'] as List<dynamic>?)
          ?.map((e) => PostImageModel.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$PostShareModelToJson(PostShareModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postBy': instance.postBy,
      'content': instance.content,
      'feeling': instance.feeling,
      'privacy': instance.privacy,
      'createdAt': instance.createdAt,
      'PostBy': instance.postByData?.toJson(),
      'PostImages': instance.postImages?.map((e) => e.toJson()).toList(),
    };
