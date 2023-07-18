import 'package:json_annotation/json_annotation.dart';

part 'post_reacts_res.g.dart';

@JsonSerializable(explicitToJson: true)
class PostReactsRes {
  bool? status;
  String? msg;
  List<PostReactData>? data;

  PostReactsRes(this.status, this.msg, this.data);

  factory PostReactsRes.fromJson(json) => _$PostReactsResFromJson(json);

  Map<String, dynamic> toJson() => _$PostReactsResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PostReactData {
  int id;
  String? nickName;
  String? profileImageUrl;
  String react;

  PostReactData(this.id, this.nickName, this.profileImageUrl, this.react);

  factory PostReactData.fromJson(json) => _$PostReactDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostReactDataToJson(this);
}
