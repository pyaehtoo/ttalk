import 'package:json_annotation/json_annotation.dart';

import 'package:teatalk/model/post.dart';

part 'sticker_per_post_res.g.dart';

@JsonSerializable()
class StickerPerPostRes {
  @JsonKey(name: 'status')
  bool? status;

  @JsonKey(name: 'msg')
  String? msg;

  @JsonKey(name: 'data')
  List<StickerPerPost>? data;
  StickerPerPostRes({
    this.status,
    this.msg,
    this.data,
  });

  factory StickerPerPostRes.fromJson(Map<String, dynamic> json) =>
      _$StickerPerPostResFromJson(json);
  Map<String, dynamic> toJson() => _$StickerPerPostResToJson(this);

  @override
  String toString() =>
      'StickerPerPostRes(status: $status, msg: $msg, data: $data)';
}

@JsonSerializable()
class StickerPerPost {
  @JsonKey(name: 'sentBy')
  int? sentBy;
  @JsonKey(name: 'postId')
  int? postId;
  @JsonKey(name: 'stickerId')
  int? stickerId;
  @JsonKey(name: 'stickerUrl')
  String? stickerUrl;
  @JsonKey(name: 'stickerAmount')
  int? stickerAmount;
  @JsonKey(name: 'createdAt')
  String? createAt;
  @JsonKey(name: 'SentBy')
  PostByModel? sentUser;
  StickerPerPost({
    this.sentBy,
    this.postId,
    this.stickerId,
    this.stickerUrl,
    this.stickerAmount,
    this.createAt,
    this.sentUser,
  });

  factory StickerPerPost.fromJson(Map<String, dynamic> json) =>
      _$StickerPerPostFromJson(json);

  Map<String, dynamic> toJson() => _$StickerPerPostToJson(this);

  @override
  String toString() {
    return 'StickerPerPost(sentBy: $sentBy, postId: $postId, stickerId: $stickerId, stickerUrl: $stickerUrl, stickerAmount: $stickerAmount, createAt: $createAt, sentUser: $sentUser)';
  }
}
