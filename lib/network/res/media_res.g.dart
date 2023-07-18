// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaRes _$MediaResFromJson(Map<String, dynamic> json) => MediaRes(
      json['status'] as bool?,
      json['msg'] as String?,
      json['data'] == null ? null : MediaData.fromJson(json['data']),
    );

Map<String, dynamic> _$MediaResToJson(MediaRes instance) => <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.toJson(),
    };

MediaData _$MediaDataFromJson(Map<String, dynamic> json) => MediaData(
      (json['postMedias'] as List<dynamic>?)
          ?.map((e) => MediaRawData.fromJson(e))
          .toList(),
      (json['profileMedias'] as List<dynamic>?)
          ?.map((e) => MediaRawData.fromJson(e))
          .toList(),
      (json['coverMedias'] as List<dynamic>?)
          ?.map((e) => MediaRawData.fromJson(e))
          .toList(),
      (json['videoMedias'] as List<dynamic>?)
          ?.map((e) => MediaRawData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$MediaDataToJson(MediaData instance) => <String, dynamic>{
      'postMedias': instance.postMedias?.map((e) => e.toJson()).toList(),
      'profileMedias': instance.profileMedias?.map((e) => e.toJson()).toList(),
      'coverMedias': instance.coverMedias?.map((e) => e.toJson()).toList(),
      'videoMedias': instance.videoMedias?.map((e) => e.toJson()).toList(),
    };

MediaRawData _$MediaRawDataFromJson(Map<String, dynamic> json) => MediaRawData(
      json['postId'] as int?,
      json['filePath'] as String?,
      json['userId'] as int?,
    );

Map<String, dynamic> _$MediaRawDataToJson(MediaRawData instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'filePath': instance.filePath,
      'userId': instance.userId,
    };
