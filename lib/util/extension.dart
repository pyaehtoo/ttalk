import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/post_privacy.dart';

extension CustomStrings on String? {
  bool get isNullOrEmpty => (this == null || this!.trim().isEmpty);
}

extension StringExtension on String {
  String firstLetterCapitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension AppHeloper on BuildContext {
  void setUserProvider(UserModel user) {
    read<UserProvider>().user = user;
  }

  PostPrivacy get selectedPrivacy => read<UserProvider>().selectedPrivacy;

  String? get token => read<UserProvider>().token;

  int? get userId => read<UserProvider>().userId;

  String? get userProfileImage =>
      read<UserProvider>().userProfile?.profileImageUrl;
}
