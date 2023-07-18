// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StickerVO _$StickerVOFromJson(Map<String, dynamic> json) => StickerVO(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      discountTotal: (json['discountTotal'] as num?)?.toDouble(),
      discountAmount: json['discountAmount'] as String?,
      discountType: json['discountType'] as String?,
      discountStart: json['discountStart'] as String?,
      discountEnd: json['discountEnd'] as String?,
    );

Map<String, dynamic> _$StickerVOToJson(StickerVO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'discountTotal': instance.discountTotal,
      'discountAmount': instance.discountAmount,
      'discountType': instance.discountType,
      'discountStart': instance.discountStart,
      'discountEnd': instance.discountEnd,
    };
