import 'package:json_annotation/json_annotation.dart';

import '../../model/buddy.dart';
import '../../model/profile.dart';

part 'find_buddy_res.g.dart';

@JsonSerializable(explicitToJson: true)
class FindBuddyRes {
  bool? status;
  String? msg;
  List<FindBuddyData>? data;

  FindBuddyRes(this.status, this.msg, this.data);

  factory FindBuddyRes.fromJson(json) => _$FindBuddyResFromJson(json);

  Map<String, dynamic> toJson() => _$FindBuddyResToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FindBuddyData {
  int id;
  String? nickName;
  String? relationshipStatus;
  int countFriends;
  @JsonKey(name: 'Profile')
  ProfileModel? profile;

  FindBuddyData(this.id, this.nickName, this.relationshipStatus,
      this.countFriends, this.profile);

  BuddyModel getBuddyModel() {
    return BuddyModel()
      ..nickName = nickName
      ..relationshipStatus = relationshipStatus
      ..totalFriends = countFriends
      ..id = id
      ..profileUrl = profile?.profileImageUrl;
  }

  factory FindBuddyData.fromJson(json) => _$FindBuddyDataFromJson(json);

  Map<String, dynamic> toJson() => _$FindBuddyDataToJson(this);
}
