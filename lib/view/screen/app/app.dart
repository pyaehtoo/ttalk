import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/notification_res.dart';
import 'package:teatalk/network/res/user_profile_res.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/provider/feed.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/screen/app/buddy/buddy_sent_request.dart';
import 'package:teatalk/view/screen/app/buddy/buddy_suggestion.dart';
import 'package:teatalk/view/screen/app/create_post.dart';
import 'package:teatalk/view/screen/app/notification.dart';
import 'package:teatalk/view/screen/app/page/account.dart';
import 'package:teatalk/view/screen/app/page/buddy_world.dart';
import 'package:teatalk/view/screen/app/page/home.dart';
import 'package:teatalk/view/screen/app/search_page.dart';
import 'package:teatalk/view/screen/auth/sign_in.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/widget/k_bottom_nav.dart';

import '../../../util/log.dart';
import '../../theme/text.dart';

enum AppPageRoute { home, friend, account }

class AppScreen extends StatefulWidget {
  final AppPageRoute? route;

  final bool? isBuddyReq;
  const AppScreen({Key? key, this.route, this.isBuddyReq}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late UserProvider _userProvider;
  late AppProvider _appProvider;
  int _index = 0;
  int _buddyIndex = 0;
  NotificationRes? notificationRes;

  @override
  void initState() {
    super.initState();
    _init();
    if (widget.route != null) {
      if (widget.route == AppPageRoute.home) {
        _index = 0;
      } else if (widget.route == AppPageRoute.friend) {
        _index = 1;
      }
      if (widget.route == AppPageRoute.account) {
        _index = 4;
      }
    } else {
      _index = 0;
    }

    if (widget.isBuddyReq ?? false) {
      _buddyIndex = 1;
    }
  }

  void _init() async {
    _userProvider = context.read();
    _appProvider = context.read();
    final UserProfileRes? userProfileRes = await AppApi.instance
        .userProfile(context: context, userId: _userProvider.user!.userId!);
    if (!mounted) return;
    if (userProfileRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong.");
      return;
    }
    _userProvider.userProfile = userProfileRes.data;
    _appProvider.loadLocations();
    _appProvider.loadReactions(context);
    await getNotification();
  }

  Future<void> getNotification() async {
    notificationRes = await AppApi.instance.getNotifications(context: context);
    if (!mounted) return;
    if (notificationRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong");
      return;
    }
    setState(() {});
  }

  void _onIndexChanged(int index) {
    if (_index == 0 && index == 0) {
      FeedProvider feedProvider = Provider.of(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        feedProvider.onRefreshAndScrollToTop(userToken: context.token);
      });
    }
    if (index == 2) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const CreatePostScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
      return;
    }
    setState(() => _index = index);
  }

  void _logout() async {
    await DbService.instance.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignInScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }
    return true;
  }

  void _goToNotification() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => NotificationScreen(
                unreadCount: notificationRes?.data?.unreadCount ?? 0,
                notificationList: notificationRes?.data?.notifications ?? []),
          ),
        )
        .then((value) => getNotification());
  }

  @override
  Widget build(BuildContext context) {
    int newNotiCount = notificationRes?.data?.getNewNotiCount() ?? 0;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            width: 130,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            // For Home index
            if (_index == 0) ...[
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
                },
                icon: Image.asset(
                  'assets/images/ic_search.png',
                  width: 21,
                  height: 21,
                ),
              ),
              IconButton(
                onPressed: _goToNotification,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/images/ic_bell.png',
                      width: 21,
                      height: 21,
                    ),
                    Visibility(
                      visible: newNotiCount > 0,
                      child: Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: kThemePrimaryColor,
                              shape: BoxShape.circle),
                          width: 18,
                          height: 18,
                          child: Center(
                              child: Text(
                            newNotiCount < 9 ? '$newNotiCount' : '9+',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
            // For Buddy World
            if (_index == 1)
              PopupMenuButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                position: PopupMenuPosition.under,
                icon: SvgPicture.asset("assets/images/ic_more.svg"),
                onSelected: (_) {
                  final String action = _;
                  Log.d(action);
                  if (_ == "suggestion") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BuddySuggestionScreen(),
                      ),
                    );
                  } else if (_ == "requested") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BuddySentRequestScreen(),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    const PopupMenuItem(
                      value: 'suggestion',
                      height: 27,
                      child: ListTile(
                          title: Text("Buddy Suggestions", style: kTextStyle)),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'requested',
                      height: 27,
                      child:
                          ListTile(title: Text("Buddy Ups", style: kTextStyle)),
                    ),
                  ];
                },
              ),
          ],
        ),
        backgroundColor: kThemeAppBgColor,
        body: SafeArea(
          child: IndexedStack(
            index: _index,
            children: [
              const HomePage(),
              BuddyWorldPage(buddyIndex: _buddyIndex),
              const Placeholder(),
              const ChatView(),
              AccountPage(logout: _logout),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavbarWidget(
          index: _index,
          onChanged: _onIndexChanged,
        ),
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Image.asset('assets/images/coming_soon.gif'),),
    );
  }
}
