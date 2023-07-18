import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/buddy.dart';

import '../../model/profile.dart';

part 'buddy_rec_list_res.g.dart';

@JsonSerializable(explicitToJson: true)
class BuddyRecListRes {
  bool? status;
  String? msg;
  List<BuddyRecListData>? data;

  BuddyRecListRes(this.status, this.msg, this.data);

  factory BuddyRecListRes.fromJson(json) => _$BuddyRecListResFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyRecListResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BuddyRecListData {
  String requestedSince;
  int status;
  int requesterId;
  @JsonKey(name: 'Requester')
  BuddyRequesterData? requester;

  BuddyRecListData(
      this.requestedSince, this.status, this.requesterId, this.requester);

  factory BuddyRecListData.fromJson(json) => _$BuddyRecListDataFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyRecListDataToJson(this);

  BuddyModel getBuddyModel() {
    return BuddyModel()
      ..nickName = requester?.nickName
      ..relationshipStatus = 'RECEIVED'
      ..id = requesterId
      ..profileUrl = requester?.profile.profileImageUrl;
  }
}

@JsonSerializable(explicitToJson: true)
class BuddyRequesterData {
  int id;
  String? nickName;
  @JsonKey(name: 'Profile')
  ProfileModel profile;

  BuddyRequesterData(this.id, this.nickName, this.profile);

  factory BuddyRequesterData.fromJson(json) =>
      _$BuddyRequesterDataFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyRequesterDataToJson(this);
}
