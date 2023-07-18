import 'package:flutter/cupertino.dart';

import '../network/api/app_layer.dart';
import '../network/res/buddy_list_res.dart';
import '../network/res/buddy_rec_list_res.dart';

class BuddyWorldProvider extends ChangeNotifier {
  final List<BuddyListData> _buddies = [];
  final List<BuddyRecListData> _buddyRequests = [];

  Future loadBuddies(
    BuildContext context, {
    bool refresh = false,
  }) async {
    final BuddyListRes? buddyListRes =
        await AppApi.instance.buddyList(context: context);
    if (refresh) {
      _buddies.clear();
    }
    _buddies.addAll(buddyListRes?.data ?? []);
    notifyListeners();
  }

  Future loadBuddyRequests(
    BuildContext context, {
    bool refresh = false,
  }) async {
    final BuddyRecListRes? buddyRecListRes =
        await AppApi.instance.getBuddyReceivedList(context: context);
    if (refresh) {
      _buddyRequests.clear();
    }
    _buddyRequests.addAll(buddyRecListRes?.data ?? []);
    notifyListeners();
  }

  List<BuddyRecListData> get buddyRequests => _buddyRequests;

  List<BuddyListData> get buddies => _buddies;

  
}
