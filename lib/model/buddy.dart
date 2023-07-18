import 'package:teatalk/model/profile.dart';

class BuddyModel {
  String? nickName;
  int totalFriends = 0;
  int mutual = 0;
  String? profileUrl;
  String? coverUrl;
  int? id;
  String? relationshipStatus;
  ProfileModel? profileModel;

  BuddyModel();

  bool isFriend(){
    return relationshipStatus == "FRIEND";
  }

  bool isNotFriend(){
    return relationshipStatus == "NOT_FRIEND";
  }

  bool isCancel(){
    return relationshipStatus == "CANCEL";
  }


}
