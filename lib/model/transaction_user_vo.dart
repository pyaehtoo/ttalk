import 'package:json_annotation/json_annotation.dart';

part 'transaction_user_vo.g.dart';

@JsonSerializable()
class TransactionUserVO {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'userName')
  String? userName;
  TransactionUserVO({
    this.id,
    this.userName,
  });

  factory TransactionUserVO.fromJson(Map<String, dynamic> json) => _$TransactionUserVOFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionUserVOToJson(this);
}
