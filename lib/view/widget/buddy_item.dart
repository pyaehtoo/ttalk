import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/network/res/find_buddy_res.dart';
import 'package:teatalk/provider/buddy_world.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/log.dart';
import 'package:teatalk/view/screen/app/diary/diary.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/app_btn.dart';
import 'package:teatalk/view/widget/avatar.dart';

import '../../model/buddy.dart';
import '../../network/api/app_layer.dart';
import '../theme/color.dart';
import '../theme/text.dart';
import 'confirm_dialog.dart';

class BuddyItemWidget extends StatefulWidget {
  final BuddyModel buddy;
  final FindBuddyData? findBuddyData;

  const BuddyItemWidget({
    Key? key,
    required this.buddy,
    this.findBuddyData,
  }) : super(key: key);

  @override
  State<BuddyItemWidget> createState() => _BuddyItemWidgetState();
}

class _BuddyItemWidgetState extends State<BuddyItemWidget> {
  late BuddyModel _buddy;
  late BuddyWorldProvider _provider;
  String? _relationshipStatus;

  @override
  void initState() {
    super.initState();
    _provider = context.read();
    _buddy = widget.buddy;
    _relationshipStatus = _buddy.relationshipStatus;
  }

  void _addFriend() async {
    AoLib.instance.showLoading(context);
    final FindBuddyRes? findBuddyRes =
        await AppApi.instance.addBuddy(context: context, userId: _buddy.id!);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (findBuddyRes?.status ?? false) {
      setState(() {
        _relationshipStatus = "CANCEL";
      });
    }
    AoLib.instance.showSnack(
      context: context,
      message: findBuddyRes?.msg ?? 'Something went wrong!',
    );
  }

  void _cancelRequested() async {
    AoLib.instance.showLoading(context);
    final FindBuddyRes? findBuddyRes = await AppApi.instance
        .cancelRequestedBuddy(context: context, userId: _buddy.id!);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (findBuddyRes?.status ?? false) {
      setState(() {
        _relationshipStatus = "NOT_FRIEND";
      });
    }
    AoLib.instance.showSnack(
      context: context,
      message: findBuddyRes?.msg ?? 'Something went wrong!',
    );
  }

  void _confirmReceived(int status) async {
    AoLib.instance.showLoading(context);
    final FindBuddyRes? findBuddyRes =
        await AppApi.instance.confirmReceivedBuddy(
      context: context,
      requestedUserId: _buddy.id!,
      status: status,
    );
    if (!mounted) return;
    if (findBuddyRes?.status ?? false) {
      if (status == 1) {
        await _provider.loadBuddies(context);
      }
      if (!mounted) return;
      await _provider.loadBuddyRequests(context);
      setState(() {
        _relationshipStatus = status == 1 ? "FRIEND" : "NOT_FRIEND";
      });
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    AoLib.instance.showSnack(
      context: context,
      message: findBuddyRes?.msg ?? 'Something went wrong!',
    );
  }

  void _unbuddy({bool askConfirm = true}) async {
    if (askConfirm) {
      showDialog(
        context: context,
        barrierColor: Colors.black45,
        builder: (_) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ConfirmDialogWidget(
            title: "Remove Buddy",
            content: "Are you sure unbuddy for ${_buddy.nickName}?",
            cancel: "Cancel",
            action: "Remove Buddy",
            crossAxisAlignment: CrossAxisAlignment.start,
            textAlign: TextAlign.start,
            height: 230,
            prefixTitle: Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset('assets/images/ic_danger.svg'),
            ),
            subContent: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarWidget(profileUrl: _buddy.profileUrl, size: 48),
                  kSpacerH,
                  kSpacerH,
                  Expanded(
                    child: Text(
                      _buddy.nickName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onCancelled: () {},
            onAction: () => _unbuddy(askConfirm: false),
          ),
        ),
      );
      return;
    }
    AoLib.instance.showLoading(context);
    final FindBuddyRes? findBuddyRes =
        await AppApi.instance.unBuddy(context: context, userId: _buddy.id!);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (findBuddyRes?.status ?? false) {
      setState(() {
        _relationshipStatus = "NOT_FRIEND";
      });
    }
    AoLib.instance.showSnack(
      context: context,
      message: findBuddyRes?.msg ?? 'Something went wrong!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? buddyName = _relationshipStatus == "FRIEND"
        ? _buddy.nickName
        : "${_buddy.nickName} (${_buddy.totalFriends} buddies)";
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DiaryScreen(
                          userId: _buddy.id,
                        )));
              },
              child: AvatarWidget(profileUrl: _buddy.profileUrl, size: 65)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DiaryScreen(userId: _buddy.id)));
                  },
                  child: Text(
                    buddyName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: kTextStyle.copyWith(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 3),
                if (_relationshipStatus == "FRIEND") ...[
                  Visibility(
                    visible: _buddy.mutual > 0,
                    child: Text(
                      "${_buddy.mutual} mutual",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle.copyWith(fontSize: 15),
                    ),
                  ),
                ] else if (_relationshipStatus == "NOT_FRIEND") ...[
                  kSpacerV,
                  Row(
                    children: [
                      Expanded(
                        child: AppButtonWidget(
                          width: 100,
                          text: "Add",
                          onPressed: _addFriend,
                        ),
                      ),
                      kSpacerH,
                      kSpacerH,
                      Expanded(
                        child: AppButtonWidget(
                          width: 100,
                          text: "Remove",
                          background: kThemeColor.withOpacity(0.4),
                          onPressed: () {
                            AoLib.instance.showSnack(
                                context: context,
                                message:
                                    'This feature is not available at the moment.');
                          },
                        ),
                      ),
                    ],
                  ),
                ] else if (_relationshipStatus == "CANCEL") ...[
                  kSpacerV,
                  Row(
                    children: [
                      AppButtonWidget(
                        width: 100,
                        text: "Cancel",
                        onPressed: _cancelRequested,
                      ),
                    ],
                  ),
                ] else ...[
                  kSpacerV,
                  Row(
                    children: [
                      Expanded(
                        child: AppButtonWidget(
                          width: 100,
                          text: "Accept",
                          onPressed: () => _confirmReceived(1),
                        ),
                      ),
                      kSpacerH,
                      kSpacerH,
                      Expanded(
                        child: AppButtonWidget(
                          width: 100,
                          text: "Cancel",
                          background: kThemeColor.withOpacity(0.4),
                          onPressed: () => _confirmReceived(0),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            position: PopupMenuPosition.over,
            icon: SvgPicture.asset("assets/images/ic_more.svg"),
            onSelected: (_) {
              final String action = _;
              if (action == "unbuddy") {
                _unbuddy();
                return;
              } else if (action == "diary") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => DiaryScreen(userId: _buddy.id),
                  ),
                );
                return;
              }
              Log.d(action);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: 'diary',
                  height: 27,
                  child:
                      ListTile(title: Text("Go To Diary", style: kTextStyle)),
                ),
                // const PopupMenuDivider(),
                // const PopupMenuItem(
                //   value: 'chat',
                //   height: 27,
                //   child: ListTile(title: Text("Go To Chat", style: kTextStyle)),
                // ),
                if (_relationshipStatus == "FRIEND") ...[
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'unbuddy',
                    height: 27,
                    child: ListTile(
                        title: Text("Remove Buddy", style: kTextStyle)),
                  ),
                ],
              ];
            },
          ),
        ],
      ),
    );
  }
}
