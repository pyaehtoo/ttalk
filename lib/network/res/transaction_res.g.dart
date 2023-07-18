// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRes _$TransactionResFromJson(Map<String, dynamic> json) =>
    TransactionRes(
      status: json['status'] as bool?,
      message: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionResToJson(TransactionRes instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.message,
      'data': instance.data,
    };
