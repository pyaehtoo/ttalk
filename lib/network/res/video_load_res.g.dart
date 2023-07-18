// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_load_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoLoadRes _$VideoLoadResFromJson(Map<String, dynamic> json) => VideoLoadRes(
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : VideoLoadVO.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoLoadResToJson(VideoLoadRes instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

VideoLoadVO _$VideoLoadVOFromJson(Map<String, dynamic> json) => VideoLoadVO(
      playAuth: json['PlayAuth'] as String?,
      videoMeta: json['VideoMeta'] == null
          ? null
          : VideoMetaVO.fromJson(json['VideoMeta'] as Map<String, dynamic>),
      requestId: json['RequestId'] as String?,
      videoUrl: json['VideoUrl'] as String?,
    );

Map<String, dynamic> _$VideoLoadVOToJson(VideoLoadVO instance) =>
    <String, dynamic>{
      'PlayAuth': instance.playAuth,
      'VideoMeta': instance.videoMeta,
      'RequestId': instance.requestId,
      'VideoUrl': instance.videoUrl,
    };

VideoMetaVO _$VideoMetaVOFromJson(Map<String, dynamic> json) => VideoMetaVO(
      status: json['Status'] as String?,
      videoId: json['VideoId'] as String?,
      title: json['Title'] as String?,
      duration: json['Duration'] as String?,
      coverUrl: json['CoverURL'] as String?,
    );

Map<String, dynamic> _$VideoMetaVOToJson(VideoMetaVO instance) =>
    <String, dynamic>{
      'Status': instance.status,
      'VideoId': instance.videoId,
      'Title': instance.title,
      'Duration': instance.duration,
      'CoverURL': instance.coverUrl,
    };
