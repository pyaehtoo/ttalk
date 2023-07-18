// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activities_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitiesRes _$ActivitiesResFromJson(Map<String, dynamic> json) =>
    ActivitiesRes(
      json['status'] as bool?,
      json['msg'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => ActivityData.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$ActivitiesResToJson(ActivitiesRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) => ActivityData(
      json['actionTo'] as String,
      json['description'] as String,
      json['createdAt'] as String,
    );

Map<String, dynamic> _$ActivityDataToJson(ActivityData instance) =>
    <String, dynamic>{
      'actionTo': instance.actionTo,
      'description': instance.description,
      'createdAt': instance.createdAt,
    };
