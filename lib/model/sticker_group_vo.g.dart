// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_group_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StickerGroupVO _$StickerGroupVOFromJson(Map<String, dynamic> json) =>
    StickerGroupVO(
      id: json['id'] as int?,
      name: json['name'] as String?,
      minAge: json['minAge'] as int?,
      maxAge: json['maxAge'] as int?,
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
      remark: json['remark'] as String?,
      stickers: (json['Stickers'] as List<dynamic>?)
          ?.map((e) => StickerVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StickerGroupVOToJson(StickerGroupVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'remark': instance.remark,
      'Stickers': instance.stickers,
    };
