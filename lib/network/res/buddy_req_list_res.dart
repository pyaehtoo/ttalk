import 'package:json_annotation/json_annotation.dart';
import 'package:teatalk/model/buddy.dart';

import '../../model/profile.dart';

part 'buddy_req_list_res.g.dart';

@JsonSerializable(explicitToJson: true)
class BuddyReqListRes {
  bool? status;
  String? msg;
  List<BuddyReqListData>? data;

  BuddyReqListRes(this.status, this.msg, this.data);

  factory BuddyReqListRes.fromJson(json) => _$BuddyReqListResFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyReqListResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BuddyReqListData {
  String requestedSince;
  int status;
  int recipientId;
  @JsonKey(name: 'Recipient')
  BuddyRecipientData? recipient;

  BuddyReqListData(
      this.requestedSince, this.status, this.recipientId, this.recipient);

  factory BuddyReqListData.fromJson(json) => _$BuddyReqListDataFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyReqListDataToJson(this);

  BuddyModel getBuddyModel() {
    return BuddyModel()
      ..nickName = recipient?.nickName
      ..relationshipStatus = 'CANCEL'
      ..id = recipientId
      ..profileUrl = recipient?.profile.profileImageUrl;
  }
}

@JsonSerializable(explicitToJson: true)
class BuddyRecipientData {
  int id;
  String? nickName;
  @JsonKey(name: 'Profile')
  ProfileModel profile;

  BuddyRecipientData(this.id, this.nickName, this.profile);

  factory BuddyRecipientData.fromJson(json) =>
      _$BuddyRecipientDataFromJson(json);

  Map<String, dynamic> toJson() => _$BuddyRecipientDataToJson(this);
}
