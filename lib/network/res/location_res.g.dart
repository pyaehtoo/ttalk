// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationRes _$LocationResFromJson(Map<String, dynamic> json) => LocationRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => LocationData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$LocationResToJson(LocationRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      json['id'] as int,
      json['parentId'] as int?,
      json['name'] as String?,
      json['createdAt'] as String?,
      json['updatedAt'] as String?,
      json['deletedAt'] as String?,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };
