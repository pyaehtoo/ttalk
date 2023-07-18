import 'package:json_annotation/json_annotation.dart';

part 'create_post_res.g.dart';

@JsonSerializable(explicitToJson: true)
class CreatePostRes {
  bool? status;
  String? msg;
  CreatePostData? data;

  CreatePostRes(this.status, this.msg, this.data);

  factory CreatePostRes.fromJson(json) => _$CreatePostResFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostResToJson(this);
}

@JsonSerializable()
class CreatePostData {
  int id, postBy;
  String? content, updatedAt;
  String privacy, feeling, createdAt;

  CreatePostData(this.id, this.postBy, this.content, this.updatedAt,
      this.privacy, this.feeling, this.createdAt);

  factory CreatePostData.fromJson(json) => _$CreatePostDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDataToJson(this);
}
