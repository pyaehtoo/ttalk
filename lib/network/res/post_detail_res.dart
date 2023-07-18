import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/post.dart';

part 'post_detail_res.g.dart';

@JsonSerializable(explicitToJson: true)
class PostDetailRes {
  bool? status;
  String? msg;
  PostModel? data;

  PostDetailRes(this.status, this.msg, this.data);

  factory PostDetailRes.fromJson(json) => _$PostDetailResFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailResToJson(this);
}
