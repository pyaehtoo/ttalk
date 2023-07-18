// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionVO _$TransactionVOFromJson(Map<String, dynamic> json) =>
    TransactionVO(
      id: json['id'] as int?,
      transactionType: json['transactionType'] as String?,
      transactionId: json['transactionId'] as String?,
      categoryId: json['categoryId'] as int?,
      stickerId: json['stickerId'] as int?,
      stickerCode: json['stickerCode'] as String?,
      stickerUrl: json['stickerUrl'] as String?,
      accountFrom: json['accountFrom'] as String?,
      accountTo: json['accountTo'] as String?,
      iceAmount: (json['iceAmount'] as num?)?.toDouble(),
      commissionTotal: (json['commissionTotal'] as num?)?.toDouble(),
      commissionAmount: json['commissionAmount'] as String?,
      commissionType: json['commissionType'] as String?,
      description: json['description'] as String?,
      postId: json['postId'] as int?,
      sentBy: json['sentBy'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      fromUser: json['From'] == null
          ? null
          : TransactionUserVO.fromJson(json['From'] as Map<String, dynamic>),
      toUser: json['To'] == null
          ? null
          : TransactionUserVO.fromJson(json['To'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionVOToJson(TransactionVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': instance.transactionType,
      'transactionId': instance.transactionId,
      'categoryId': instance.categoryId,
      'stickerId': instance.stickerId,
      'stickerCode': instance.stickerCode,
      'stickerUrl': instance.stickerUrl,
      'accountFrom': instance.accountFrom,
      'accountTo': instance.accountTo,
      'iceAmount': instance.iceAmount,
      'commissionTotal': instance.commissionTotal,
      'commissionAmount': instance.commissionAmount,
      'commissionType': instance.commissionType,
      'description': instance.description,
      'postId': instance.postId,
      'sentBy': instance.sentBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'From': instance.fromUser,
      'To': instance.toUser,
    };
