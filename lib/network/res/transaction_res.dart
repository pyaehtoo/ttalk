import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/transaction_vo.dart';

part 'transaction_res.g.dart';

@JsonSerializable()
class TransactionRes {
  @JsonKey(name: 'status')
  bool? status;

  @JsonKey(name: 'msg')
  String? message;

  @JsonKey(name: 'data')
  List<TransactionVO>? data;

  TransactionRes({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionRes.fromJson(Map<String, dynamic> json) =>
      _$TransactionResFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResToJson(this);
}
