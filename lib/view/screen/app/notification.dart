import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/screen/app/app.dart';
import 'package:teatalk/view/screen/app/diary/diary.dart';
import 'package:teatalk/view/screen/app/page/account.dart';
import 'package:teatalk/view/screen/app/post_detail.dart';
import 'package:teatalk/view/widget/avatar.dart';

import '../../../network/res/notification_res.dart';
import '../../theme/color.dart';
import '../../theme/dimens.dart';
import '../../theme/text.dart';

class NotificationScreen extends StatefulWidget {
  final List<NotificationModel> notificationList;
  final int unreadCount;
  const NotificationScreen(
      {Key? key, required this.notificationList, required this.unreadCount})
      : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DateFormat dateFormat = DateFormat("MMM dd, yyyy");
  final DateFormat notiDateFormat = DateFormat("EEEE, MMMM");
  final DateFormat notiTimeFormat = DateFormat("hh:mm a");
  final List<String> _filteredDate = [];
  final Map<String, List<NotificationModel>> _filterNotifications = {};
  List<NotificationModel> _notificationList = [];
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _makeNotiView();
  }

  Future<void> _loadNotifications() async {
    // final NotificationRes? notificationRes =
    //     await AppApi.instance.getNotifications(context: context);
    // if (!mounted) return;
    // if (notificationRes == null) {
    //   AoLib.instance
    //       .showSnack(context: context, message: "Something went wrong");
    //   return;
    // }
    _notificationList = widget.notificationList;
    _unreadCount = widget.unreadCount;
    for (final NotificationModel noti in _notificationList) {
      final date = DateTime.parse(noti.createdAt);
      final String formattedDate = dateFormat.format(date);
      if (!_filteredDate.contains(formattedDate)) {
        _filteredDate.add(formattedDate);
      }
      final List<NotificationModel> tmpList =
          _filterNotifications[formattedDate] ?? [];
      tmpList.add(noti);
      _filterNotifications[formattedDate] = tmpList;
    }
    setState(() {});
  }

  void _tapNotification(BuildContext context, NotificationModel noti) async {
    if (noti.isRead != 0) {
      await AppApi.instance
          .readNotification(token: context.token!, notiId: noti.id)
          .then((value) {
        _makeNotiRead(noti.id);
        _goToPageAccordingToNotiType(context, noti);
      });
    } else {
      _goToPageAccordingToNotiType(context, noti);
    }
  }

  void _makeNotiRead(int notiId) {
    for (final NotificationModel noti in _notificationList) {
      if (noti.id == notiId) {
        noti.isRead = 0;
      }
    }
    setState(() {});
  }

  void _makeNotiView() {
    List<int> notiList = [];
    for (NotificationModel noti in _notificationList) {
      if (noti.isRead == 1) {
        notiList.add(noti.id);
      }
    }
    print(notiList);

    AppApi.instance
        .viewNotification(token: context.token!, notiIdList: notiList);
  }

  void _goToPageAccordingToNotiType(
      BuildContext context, NotificationModel noti) async {
    if (noti.notiableType == 'FRIEND_REQUEST') {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const AppScreen(isBuddyReq: true, route: AppPageRoute.friend),
          ));
    } else if (noti.notiableType == 'FRIEND_ACCEPTED') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DiaryScreen(userId: noti.sourceId)));
    } else if (noti.notiableType == 'REACT_TO_POST' ||
        noti.notiableType == 'STICKER_TO_POST') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              postId: noti.notiableId,
              action: 'view',
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: kThemeWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          "Notification",
          style: kTextStyle.copyWith(fontSize: 17),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: kThemeWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kSpacerV,
            kSpacerV,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kAppGapDimens),
              child: Text(
                "All (${_notificationList.length})/ ($_unreadCount) Unread",
                style: kTextStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: _filteredDate.length,
                itemBuilder: (context, index) {
                  final String formattedDate = _filteredDate[index];
                  final List<NotificationModel> tmpNoti =
                      _filterNotifications[formattedDate] ?? [];
                  return StickyHeader(
                    header: Container(
                      color: kThemeWhite,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: kAppGapDimens),
                      child: Text(
                        formattedDate,
                        style: kTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    content: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: tmpNoti.length,
                      itemBuilder: (c, i) {
                        final NotificationModel noti = tmpNoti[i];
                        final DateTime date = DateTime.parse(noti.createdAt);
                        final DateTime calculatedTimeForMMT = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          date.hour + 6,
                          date.minute + 30,
                        );

                        final String createdAt =
                            '${notiDateFormat.format(date)} | Time: ${notiTimeFormat.format(calculatedTimeForMMT)}';
                        return InkWell(
                          onTap: () {
                            _tapNotification(context, noti);
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 1.5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: kAppGapDimens, vertical: 18),
                            decoration: BoxDecoration(
                              //TODO need to change condition
                              color: (noti?.isRead != 0 ?? false)
                                  ? kNotiUnreadColor
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                AvatarWidget(
                                  profileUrl:
                                      noti.sourceUser?.profile?.profileImageUrl,
                                  size: 55,
                                ),
                                kSpacerH,
                                kSpacerH,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noti.sourceUser?.nickName ?? noti.title,
                                        style: kTextStyle.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        noti.message,
                                        style: kTextStyle.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        createdAt,
                                        style: kTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
