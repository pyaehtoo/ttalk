import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../model/post.dart';

part 'comments_res.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentsRes {
  bool? status;
  String? msg;

  List<CommentsData>? data;

  CommentsRes(this.status, this.msg, this.data);

  factory CommentsRes.fromJson(Map<String, dynamic> json) =>
      _$CommentsResFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CommentsData {
  int id;
  String? comment;
  int? parentId;
  int replyCount;
  int reactCount;
  int reactByMe;
  String createdAt;
  bool? isViewAllComment;
  @JsonKey(name: 'Commenter')
  PostByModel commenter;

  CommentsData(
      this.id,
      this.comment,
      this.parentId,
      this.replyCount,
      this.reactCount,
      this.reactByMe,
      this.createdAt,
      this.commenter);

  factory CommentsData.fromJson(Map<String, dynamic> json) =>
      _$CommentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsDataToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommentsData &&
      other.id == id &&
      other.comment == comment &&
      other.parentId == parentId &&
      other.replyCount == replyCount &&
      other.reactCount == reactCount &&
      other.reactByMe == reactByMe &&
      other.createdAt == createdAt &&
      other.isViewAllComment == isViewAllComment &&
      other.commenter == commenter;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      comment.hashCode ^
      parentId.hashCode ^
      replyCount.hashCode ^
      reactCount.hashCode ^
      reactByMe.hashCode ^
      createdAt.hashCode ^
      isViewAllComment.hashCode ^
      commenter.hashCode;
  }
}
