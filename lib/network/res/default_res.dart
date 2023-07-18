import 'package:json_annotation/json_annotation.dart';

part 'default_res.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultRes {
  bool? status;
  String? msg;

  DefaultRes(this.status, this.msg);

  factory DefaultRes.fromJson(json) => _$DefaultResFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultResToJson(this);
}
