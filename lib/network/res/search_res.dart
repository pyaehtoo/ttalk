import 'package:json_annotation/json_annotation.dart';

import 'package:teatalk/model/buddy.dart';
import 'package:teatalk/model/post.dart';
import 'package:teatalk/model/profile.dart';

part 'search_res.g.dart';

@JsonSerializable()
class SearchRes {
  bool? status;
  String? msg;
  SearchResData? data;

  SearchRes(this.status, this.msg, this.data);

  factory SearchRes.fromJson(Map<String, dynamic> json) =>
      _$SearchResFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResToJson(this);

  @override
  String toString() => 'SearchRes(status: $status, msg: $msg)';
}

@JsonSerializable()
class SearchResData {
  List<AccountData>? accounts;
  List<PostModel>? posts;
  SearchResData({
    this.accounts,
    this.posts,
  });

  factory SearchResData.fromJson(Map<String, dynamic> json) =>
      _$SearchResDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResDataToJson(this);

  @override
  String toString() => 'SearchResData(accounts: $accounts, posts: $posts)';
}

@JsonSerializable()
class AccountData {
  int? id;
  String? nickName;
  ProfileModel? profile;
  String? relationshipStatus;
  int? countFriends;
  AccountData({
    this.id,
    this.nickName,
    this.profile,
    this.relationshipStatus,
    this.countFriends,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);

  BuddyModel getBuddyModel() {
    return BuddyModel()
      ..nickName = nickName
      ..relationshipStatus = relationshipStatus
      ..id = id
      ..profileUrl = profile?.profileImageUrl ?? ''
      ..profileModel = profile;
  }

  @override
  String toString() {
    return 'AccountData(id: $id, nickName: $nickName, profile: ${profile.toString()}, relationshipStatus: $relationshipStatus, countFriends: $countFriends)';
  }
}
