// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_upload_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoUploadRes _$VideoUploadResFromJson(Map<String, dynamic> json) =>
    VideoUploadRes(
      json['message'] as String?,
      json['data'] == null
          ? null
          : VideoUploadResData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoUploadResToJson(VideoUploadRes instance) =>
    <String, dynamic>{
      'message': instance.msg,
      'data': instance.data,
    };

VideoUploadResData _$VideoUploadResDataFromJson(Map<String, dynamic> json) =>
    VideoUploadResData(
      videoId: json['videoId'] as String?,
    );

Map<String, dynamic> _$VideoUploadResDataToJson(VideoUploadResData instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
    };
