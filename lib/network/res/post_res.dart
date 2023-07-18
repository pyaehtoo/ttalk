import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/post.dart';

part 'post_res.g.dart';

@JsonSerializable(explicitToJson: true)
class PostRes {
  bool? status;
  String? msg;
  List<PostModel>? data;
  int? count;

  PostRes(this.status, this.msg, this.data, this.count);

  factory PostRes.fromJson(json) => _$PostResFromJson(json);

  Map<String, dynamic> toJson() => _$PostResToJson(this);
}
