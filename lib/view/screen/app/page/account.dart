import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/screen/app/page/account_setting_page.dart';
import 'package:teatalk/view/screen/app/page/agent_page.dart';
import 'package:teatalk/view/screen/app/page/privacy_policy_page.dart';
import 'package:teatalk/view/screen/app/page/receive_histroy_page.dart';
import 'package:teatalk/view/screen/app/page/sent_history_page.dart';
import 'package:teatalk/view/screen/app/page/wallet_page.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/theme/widget.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:teatalk/view/widget/link_btn.dart';

import '../../../widget/account_toggle_widget.dart';
import '../diary/diary.dart';

class AccountPage extends StatefulWidget {
  final Function() logout;

  const AccountPage({Key? key, required this.logout}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  double iceCubeCount = 0;
  @override
  void initState() {
    super.initState();
    getIceCubeCount();
  }

  void getIceCubeCount() async {
    await AppApi.instance.getIceCubeCount(token: context.token!).then((res) {
      setState(() {
        iceCubeCount = res?.getIceCount() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch();
    userProvider.loadUser(context);
    final UserProfileModel? userProfile = userProvider.userProfile;
    final UserModel? userModel = userProvider.user;
    if (userProfile == null || userModel == null) return const SizedBox();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: kAppGapDimens,
                right: kAppGapDimens,
                top: kAppGapDimens,
                bottom: 18),
            child: Row(
              children: [
                AvatarWidget(profileUrl: userProfile.profileImageUrl, size: 80),
                kSpacerH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile.nickName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Account ID - ${userProfile.imsAccountId}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(fontSize: 15),
                          ),
                          kSpacerH,
                          GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                        text: userProfile.accountId.toString()))
                                    .then((value) => AoLib.instance
                                        .showToast("Copy To Clipboard"));
                              },
                              child: const Icon(
                                Icons.copy,
                                color: kThemeTextColor,
                                size: 15,
                              ))
                        ],
                      ),
                      const SizedBox(height: 8),
                      IceCubeCount(count: iceCubeCount.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1),
          const SizedBox(
            height: 18,
          ),
          AccountButtonGroupView(
            logout: () {
              widget.logout();
            },
            onTapDiary: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          DiaryScreen(userId: userModel.userId)))
                  .then((value) => userProvider.loadUser(context));
            },
          ),
          const SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }
}

class IceCubeCount extends StatelessWidget {
  final String count;
  final double iceCubeSize;
  final double midPadding;
  final double fontSize;
  const IceCubeCount({
    super.key,
    required this.count,
    this.midPadding = 8,
    this.iceCubeSize = 18,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: iceCubeSize,
          height: iceCubeSize,
          child: Image.asset('assets/images/ice.png'),
        ),
        SizedBox(
          width: midPadding,
        ),
        Text(
          count,
          style: kTextStyle.copyWith(
              fontWeight: FontWeight.w400, fontSize: fontSize),
        )
      ],
    );
  }
}

class AccountButtonGroupView extends StatelessWidget {
  final Function logout;
  final Function onTapDiary;
  const AccountButtonGroupView({
    super.key,
    required this.logout,
    required this.onTapDiary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      decoration:
          const BoxDecoration(color: Colors.white, boxShadow: kBoxShadowList),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AccountToggleButtonWidget(
            title: "My Diary",
            icon: 'assets/images/diary.png',
            onPressed: () {
              onTapDiary();
            },
          ),
          AccountToggleButtonWidget(
            title: "Wallet",
            icon: 'assets/images/wallet.png',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WalletPage()));
            },
          ),
          AccountToggleButtonWidget(
            title: "Agent",
            icon: 'assets/images/agent.png',
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AgentPage()));
            },
          ),
          AccountToggleButtonWidget(
            title: "Sensation Board",
            icon: 'assets/images/sensational_board.png',
            onPressed: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountToggleButtonWidget(
                  icon: 'assets/images/sent_history.png',
                  title: "Sent History",
                  isSubChild: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SentHistoryPage()));
                  },
                ),
                AccountToggleButtonWidget(
                  icon: 'assets/images/received_history.png',
                  title: "Received History",
                  isSubChild: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ReceiveHistoryPage()));
                  },
                ),
              ],
            ),
          ),
          AccountToggleButtonWidget(
            title: "Account Setting",
            icon: 'assets/images/account_setting.png',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AccountSettingPage()));
            },
          ),
          AccountToggleButtonWidget(
            title: "Privacy Policy",
            icon: 'assets/images/privacy_policy.png',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage()));
            },
          ),
          AccountToggleButtonWidget(
            icon: 'assets/images/sign_out.png',
            title: "Sign Out",
            onPressed: () {
              AoLib.instance.showConfirmDialog(
                context,
                title: 'Are you sure',
                content: 'You want to logout?',
                action: 'Logout',
                onActionPressed: () {
                  logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
