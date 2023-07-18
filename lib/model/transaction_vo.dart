import 'package:json_annotation/json_annotation.dart';

import 'package:teatalk/model/transaction_user_vo.dart';

part 'transaction_vo.g.dart';

@JsonSerializable()
class TransactionVO {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'transactionType')
  String? transactionType;

  @JsonKey(name: 'transactionId')
  String? transactionId;

  @JsonKey(name: 'categoryId')
  int? categoryId;

  @JsonKey(name: 'stickerId')
  int? stickerId;

  @JsonKey(name: 'stickerCode')
  String? stickerCode;

  @JsonKey(name: 'stickerUrl')
  String? stickerUrl;

  @JsonKey(name: 'accountFrom')
  String? accountFrom;

  @JsonKey(name: 'accountTo')
  String? accountTo;

  @JsonKey(name: 'iceAmount')
  double? iceAmount;

  @JsonKey(name: 'commissionTotal')
  double? commissionTotal;

  @JsonKey(name: 'commissionAmount')
  String? commissionAmount;

  @JsonKey(name: 'commissionType')
  String? commissionType;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'postId')
  int? postId;

  @JsonKey(name: 'sentBy')
  int? sentBy;

  @JsonKey(name: 'createdAt')
  String? createdAt;

  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  @JsonKey(name: 'From')
  TransactionUserVO? fromUser;

  @JsonKey(name: 'To')
  TransactionUserVO? toUser;

  TransactionVO({
    this.id,
    this.transactionType,
    this.transactionId,
    this.categoryId,
    this.stickerId,
    this.stickerCode,
    this.stickerUrl,
    this.accountFrom,
    this.accountTo,
    this.iceAmount,
    this.commissionTotal,
    this.commissionAmount,
    this.commissionType,
    this.description,
    this.postId,
    this.sentBy,
    this.createdAt,
    this.updatedAt,
    this.fromUser,
    this.toUser,
  });

  factory TransactionVO.fromJson(Map<String, dynamic> json) =>
      _$TransactionVOFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionVOToJson(this);
}
