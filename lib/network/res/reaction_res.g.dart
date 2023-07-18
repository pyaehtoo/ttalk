// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionRes _$ReactionResFromJson(Map<String, dynamic> json) => ReactionRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => ReactionData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$ReactionResToJson(ReactionRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

ReactionData _$ReactionDataFromJson(Map<String, dynamic> json) => ReactionData(
      json['name'] as String,
      json['key'] as String,
      json['icon_gif'] as String,
      json['icon_svg'] as String,
    );

Map<String, dynamic> _$ReactionDataToJson(ReactionData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'key': instance.key,
      'icon_gif': instance.iconGif,
      'icon_svg': instance.iconSvg,
    };
