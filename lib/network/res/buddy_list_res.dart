import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/buddy.dart';
import 'package:teatalk/model/profile.dart';

part 'buddy_list_res.g.dart';

@JsonSerializable(explicitToJson: true)
class BuddyListRes {
  bool? status;
  String? msg;
  List<BuddyListData>? data;

  BuddyListRes(this.status, this.msg, this.data);

  factory BuddyListRes.fromJson(json) => _$BuddyListResFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyListResToJson(this);
}

@JsonSerializable()
class BuddyListData {
  String friendshipSince;
  int friendId;
  String? nickName;
  String? bio;
  String? profileImageUrl;
  String? coverImageUrl;

  BuddyListData(this.friendshipSince, this.friendId, this.nickName, this.bio,
      this.profileImageUrl, this.coverImageUrl);

  factory BuddyListData.fromJson(json) => _$BuddyListDataFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyListDataToJson(this);

  BuddyModel getBuddyModel() {
    return BuddyModel()
      ..nickName = nickName
      ..relationshipStatus = 'FRIEND'
      ..id = friendId
      ..profileUrl = profileImageUrl
      ..profileModel = ProfileModel(
          friendId, nickName, bio, profileImageUrl, coverImageUrl, null);
  }
}
