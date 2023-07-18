import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/user_profile_res.dart';
import 'package:teatalk/util/ao_lib.dart';

import '../model/user_profile.dart';
import '../util/post_privacy.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserProfileModel? _userProfile;
  PostPrivacy _selectedPrivacy = PostPrivacy.public;

  Future<void> loadUser(BuildContext context) async {
    final UserProfileRes? userProfileRes = await AppApi.instance
        .userProfile(context: context, userId: _user!.userId!);

    if (userProfileRes == null) {
      AoLib.instance.showToast("Something went wrong.");
      return;
    }
    _userProfile = userProfileRes.data;
  }

  UserModel? get user => _user;

  set user(UserModel? value) {
    _user = value;
    notifyListeners();
  }

  UserProfileModel? get userProfile => _userProfile;

  set userProfile(UserProfileModel? value) {
    _userProfile = value;
    notifyListeners();
  }

  String? get token => user?.authToken;

  int? get userId => user?.userId;

  PostPrivacy get selectedPrivacy => _selectedPrivacy;

  set selectedPrivacy(PostPrivacy? value) {
    if (value == null) return;
    _selectedPrivacy = value;
    notifyListeners();
  }
}
