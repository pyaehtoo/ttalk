// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StickerRes _$StickerResFromJson(Map<String, dynamic> json) => StickerRes(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StickerGroupVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StickerResToJson(StickerRes instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };
