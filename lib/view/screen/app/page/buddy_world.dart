import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teatalk/network/res/buddy_list_res.dart';
import 'package:teatalk/network/res/buddy_rec_list_res.dart';
import 'package:teatalk/provider/buddy_world.dart';
import 'package:teatalk/view/screen/app/buddy/buddy_suggestion.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/search.dart';

import '../../../theme/color.dart';
import '../../../widget/app_btn.dart';
import '../../../widget/buddy_item.dart';

class BuddyWorldPage extends StatefulWidget {
  final int? buddyIndex;
  const BuddyWorldPage({Key? key, this.buddyIndex}) : super(key: key);

  @override
  State<BuddyWorldPage> createState() => _BuddyWorldPageState();
}

class _BuddyWorldPageState extends State<BuddyWorldPage> {
  late final PageController _controller;
  late BuddyWorldProvider _buddyWorldProvider;
  final RefreshController _buddyListController =
      RefreshController(initialRefresh: false);
  final RefreshController _buddyRequestController =
      RefreshController(initialRefresh: false);

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _init();
    if (widget.buddyIndex != null) {
      _index = widget.buddyIndex ?? 0;
      _controller = PageController(initialPage: _index);
    } else {
      _controller = PageController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _buddyListController.dispose();
    _buddyRequestController.dispose();
    super.dispose();
  }

  void _init() async {
    _buddyWorldProvider = context.read();
    _buddyWorldProvider.loadBuddies(context, refresh: true);
    _buddyWorldProvider.loadBuddyRequests(context, refresh: true);
  }

  void _refreshBuddy() async {
    await _buddyWorldProvider.loadBuddies(context, refresh: true);
    if (!mounted) return;
    _buddyListController.refreshCompleted();
  }

  void _refreshBuddyRequest() async {
    await _buddyWorldProvider.loadBuddyRequests(context, refresh: true);
    if (!mounted) return;
    _buddyRequestController.refreshCompleted();
  }

  void _onPageChanged(int i, {bool fromPageView = true}) {
    if (i == _index) return;
    setState(() => _index = i);
    if (!fromPageView) {
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    }
    if (_index == 0) {
      _buddyWorldProvider.loadBuddies(context, refresh: true);
    } else {
      _buddyWorldProvider.loadBuddyRequests(context, refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final BuddyWorldProvider buddyWorldProvider = context.watch();
    final List<BuddyListData> buddies = buddyWorldProvider.buddies;
    final List<BuddyRecListData> buddyRequests =
        buddyWorldProvider.buddyRequests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kAppGapDimens),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppButtonWidget(
                        text: "MY BUDDY",
                        fontColor: _index == 0 ? Colors.white : Colors.black,
                        background: _index == 0
                            ? kThemePrimaryColor
                            : Colors.transparent,
                        onPressed: () => _onPageChanged(0, fromPageView: false),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AppButtonWidget(
                        text: "BUDDY REQUEST",
                        fontColor: _index == 1 ? Colors.white : Colors.black,
                        background: _index == 1
                            ? kThemePrimaryColor
                            : Colors.transparent,
                        onPressed: () => _onPageChanged(1, fromPageView: false),
                      ),
                    ),
                  ],
                ),
              ),
              SearchWidget(
                hint: "Search buddy",
                onSubmit: (searchKey) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuddySuggestionScreen(
                            searchKey: searchKey,
                          )));
                },
              ),
              const SizedBox(height: 20),
              (_index == 0)
                  ? Text("You have ${buddies.length} buddies.")
                  : Text("You have ${buddyRequests.length} buddy requests."),
              kSpacerV,
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: _onPageChanged,
            children: [
              // Friend list
              SmartRefresher(
                controller: _buddyListController,
                onRefresh: _refreshBuddy,
                enablePullDown: true,
                enablePullUp: false,
                header: const WaterDropHeader(waterDropColor: kThemeColor),
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    left: kAppGapDimens,
                    right: 12,
                    bottom: 50,
                  ),
                  itemBuilder: (c, i) {
                    final BuddyListData buddy = buddies[i];
                    return BuddyItemWidget(buddy: buddy.getBuddyModel());
                  },
                  separatorBuilder: (c, i) {
                    return const Padding(
                      padding: EdgeInsets.only(right: kAppGapDimens - 12),
                      child: Divider(height: 10),
                    );
                  },
                  itemCount: buddies.length,
                ),
              ),
              // Friend request
              SmartRefresher(
                controller: _buddyRequestController,
                onRefresh: _refreshBuddyRequest,
                enablePullDown: true,
                enablePullUp: false,
                header: const WaterDropHeader(waterDropColor: kThemeColor),
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    left: kAppGapDimens,
                    right: 12,
                    bottom: 50,
                  ),
                  itemBuilder: (c, i) {
                    final BuddyRecListData buddy = buddyRequests[i];
                    return BuddyItemWidget(buddy: buddy.getBuddyModel());
                  },
                  separatorBuilder: (c, i) {
                    return const Padding(
                      padding: EdgeInsets.only(right: kAppGapDimens - 12),
                      child: Divider(height: 10),
                    );
                  },
                  itemCount: buddyRequests.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
