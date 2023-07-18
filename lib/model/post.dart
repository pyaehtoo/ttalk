import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:teatalk/model/profile.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class PostModel {
  int id, postBy, commentCount, reactCount, reactByMe;
  int? shareCount;
  int? stickerCount;
  int? parentId;
  String? content, feeling, privacy, createdAt;
  @JsonKey(name: 'PostBy')
  PostByModel? postByData;
  @JsonKey(name: 'PostImages')
  List<PostImageModel>? postImages;
  @JsonKey(name: 'Reacts')
  List<PostReactModel>? reacts;
  @JsonKey(name: 'Share')
  PostShareModel? share;

  PostModel(
      this.id,
      this.postBy,
      this.commentCount,
      this.reactCount,
      this.reactByMe,
      this.stickerCount,
      this.shareCount,
      this.parentId,
      this.content,
      this.feeling,
      this.privacy,
      this.createdAt,
      this.postByData,
      this.postImages,
      this.reacts,
      this.share);

  factory PostModel.fromJson(json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
  @JsonKey(includeFromJson: false, includeToJson: false)
  String heroPrefix = "";
  

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PostModel &&
      other.shareCount == shareCount &&
      other.parentId == parentId &&
      other.createdAt == createdAt &&
      other.postByData == postByData &&
      listEquals(other.postImages, postImages) &&
      listEquals(other.reacts, reacts) &&
      other.share == share;
  }

  @override
  int get hashCode {
    return shareCount.hashCode ^
      parentId.hashCode ^
      createdAt.hashCode ^
      postByData.hashCode ^
      postImages.hashCode ^
      reacts.hashCode ^
      share.hashCode;
  }
}

@JsonSerializable(explicitToJson: true)
class PostByModel {
  int id;
  String? nickName;
  @JsonKey(name: 'Profile')
  ProfileModel? profile;

  PostByModel(this.id, this.nickName, this.profile);

  factory PostByModel.fromJson(json) => _$PostByModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostByModelToJson(this);
}

@JsonSerializable()
class PostImageModel {
  int id;
  String? filePath;
  String? mediableType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? heroPrefix;

  PostImageModel(this.id, this.filePath, this.mediableType);

  factory PostImageModel.fromJson(json) => _$PostImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostImageModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PostReactModel {
  int id;
  String reactableType;
  int reactableId;
  int reacterId;
  String react;
  String createdAt;
  String updatedAt;
  @JsonKey(name: 'Reacter')
  ProfileModel? reacter;

  PostReactModel(this.id, this.reactableType, this.reactableId, this.reacterId,
      this.react, this.createdAt, this.updatedAt, this.reacter);

  factory PostReactModel.fromJson(json) => _$PostReactModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostReactModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PostShareModel {
  int id;
  int postBy;
  String? content, feeling, privacy, createdAt;
  @JsonKey(name: 'PostBy')
  PostByModel? postByData;
  @JsonKey(name: 'PostImages')
  List<PostImageModel>? postImages;

  PostShareModel(this.id, this.postBy, this.content, this.feeling, this.privacy,
      this.createdAt, this.postByData, this.postImages);

  factory PostShareModel.fromJson(json) => _$PostShareModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostShareModelToJson(this);
}
