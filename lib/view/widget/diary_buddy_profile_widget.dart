// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/model/buddy.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/find_buddy_res.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/app_btn.dart';
import 'package:teatalk/view/widget/confirm_dialog.dart';

import '../theme/text.dart';
import 'avatar.dart';

class DiaryBuddyProfileWidget extends StatefulWidget {
  final UserProfileModel? userProfile;
  final int photoCount;
  final int videoCount;

  const DiaryBuddyProfileWidget({
    Key? key,
    required this.userProfile,
    required this.photoCount,
    required this.videoCount,
  }) : super(key: key);

  @override
  State<DiaryBuddyProfileWidget> createState() =>
      _DiaryBuddyProfileWidgetState();
}

class _DiaryBuddyProfileWidgetState extends State<DiaryBuddyProfileWidget> {
  String? _relationshipStatus;

  @override
  void initState() {
    super.initState();
    _relationshipStatus = widget.userProfile?.relationshipStatus ?? '';
  }

  void _addFriend() async {
    AoLib.instance.showLoading(context);
    final FindBuddyRes? findBuddyRes = await AppApi.instance
        .addBuddy(context: context, userId: widget.userProfile?.userId ?? 0);
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
        .cancelRequestedBuddy(
            context: context, userId: widget.userProfile?.userId ?? 0);
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
            content:
                "Are you sure unbuddy for ${widget.userProfile?.nickName}?",
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
                  AvatarWidget(
                      profileUrl: widget.userProfile?.profileImageUrl ?? '',
                      size: 48),
                  kSpacerH,
                  kSpacerH,
                  Expanded(
                    child: Text(
                      widget.userProfile?.nickName ?? '',
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
    final FindBuddyRes? findBuddyRes = await AppApi.instance
        .unBuddy(context: context, userId: widget.userProfile?.userId ?? 0);
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
    String getButtonText() {
      if (_relationshipStatus == 'FRIEND') {
        return 'Remove Buddy';
      } else if (_relationshipStatus == 'NOT_FRIEND') {
        return 'Add Buddy';
      } else if (_relationshipStatus == 'CANCEL') {
        return 'Cancel';
      } else {
        return '';
      }
    }

    void onTapFriendButton() {
      if (_relationshipStatus == 'FRIEND') {
        _unbuddy();
      } else if (_relationshipStatus == 'NOT_FRIEND') {
        _addFriend();
      } else if (_relationshipStatus == 'CANCEL') {
        _cancelRequested();
      } else {
        return;
      }
    }

    String postCountText = (widget.userProfile?.postCount == 0 ||
            widget.userProfile?.postCount == 1)
        ? 'Post'
        : 'Posts';
    String photoCountText =
        (widget.photoCount == 0 || widget.photoCount == 1) ? 'Photo' : 'Photos';
    String vidoeCountText =
        (widget.videoCount == 0 || widget.videoCount == 1) ? 'Video' : 'Videos';

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.userProfile?.coverImageUrl?.isNullOrEmpty ?? true)
                  Positioned(
                    child: Container(height: 175, color: Colors.grey.shade300),
                  )
                else
                  Positioned(
                    child: SizedBox(
                        height:
                            (MediaQuery.of(context).size.height * 0.25) - 25,
                        child: Image.network(
                          widget.userProfile?.coverImageUrl ?? '',
                          width: double.infinity,
                          height: 225,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey.shade300);
                          },
                        )
                        // CachedNetworkImage(
                        //   imageUrl: widget.userProfile?.coverImageUrl ?? '',
                        //   placeholder: (c, s) =>
                        //       Container(color: Colors.grey.shade300),
                        //   errorWidget: (c, s, d) =>
                        //       Container(color: Colors.grey.shade300),
                        //   width: double.infinity,
                        //   height: 225,
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: AvatarWidget(
                      profileUrl: widget.userProfile?.profileImageUrl,
                      size: 90,
                      displayBorder: true,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.userProfile?.nickName ?? 'Loading',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: kBuddyProfileNameTextColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "@${widget.userProfile?.uniqueName ?? 'loading'}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: kBuddyProfileNameTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.userProfile?.postCount ?? 0} $postCountText',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: kBuddyProfileNameTextColor),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                '${widget.photoCount} $photoCountText',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: kBuddyProfileNameTextColor),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                '${widget.videoCount} $vidoeCountText',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: kBuddyProfileNameTextColor),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          // Add buddy and chat section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButtonWidget(
                width: 136,
                height: 34,
                fontSize:
                    (MediaQuery.of(context).devicePixelRatio < 2.2) ? 13 : 15,
                text: getButtonText(),
                fontColor: Colors.white,
                onPressed: () {
                  onTapFriendButton();
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Visibility(
                visible: false,
                child: AppButtonWidget(
                  width: 136,
                  text: "Chat",
                  height: 34,
                  fontSize:
                      (MediaQuery.of(context).devicePixelRatio < 2.2) ? 13 : 15,
                  background: kThemeUnselectedColor,
                  fontColor: Colors.black,
                  isBorder: false,
                  onPressed: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
