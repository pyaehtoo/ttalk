import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teatalk/model/buddy.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/media_res.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/constant.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/screen/app/diary/page/about.dart';
import 'package:teatalk/view/screen/app/diary/page/activity.dart';
import 'package:teatalk/view/screen/app/diary/page/media.dart';
import 'package:teatalk/view/screen/app/diary/update.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/diary_buddy_profile_widget.dart';
import 'package:teatalk/view/widget/diary_profile_widget.dart';

import '../../../../model/post.dart';
import '../../../../network/res/activities_res.dart';
import '../../../../network/res/post_res.dart';
import '../../../../network/res/user_profile_res.dart';
import '../../../theme/color.dart';
import '../../../theme/text.dart';
import '../../../widget/post_item.dart';

class DiaryScreen extends StatefulWidget {
  final int? userId;
  const DiaryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  final RefreshController _mediaController =
      RefreshController(initialRefresh: false);
  late TabController _tabController;

  UserProfileModel? _userProfile;
  List<ActivityData> _activities = [];
  MediaData? _mediaData;
  List<MediaRawData>? selectedImageList;
  int selectedImageIndex = 0;
  bool? isProfileAndCover;

  bool _isLoggedInUser = false;

  int selectedIndex = 0;

  bool isLoading = true;

  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _init();
  }

  void _init() async {
    if (widget.userId == null) {
      Navigator.of(context).pop();
      return;
    }
    await loadUserProfile();
  }

  void onTapImageList(
      List<MediaRawData> list, int index, bool isProfileACover) {
    setState(() {
      _pageController = PageController(initialPage: index);
      selectedImageList = list;
      selectedImageIndex = index;
      isProfileAndCover = isProfileACover;
    });
  }

  Future<void> deletePhoto() async {
    double currentPage = _pageController?.page ?? 0;
    int index = currentPage.toInt();
    print(index);

    // int id = selectedImageList[index]
  }

  Future<void> loadUserProfile() async {
    UserProfileRes? userProfileRes;
    setState(() {
      isLoading = true;
    });
    await AppApi.instance
        .userProfile(
      context: context,
      userId: widget.userId!,
    )
        .then((returnValue) async {
      userProfileRes = returnValue;
      if (!mounted) return;
      if (userProfileRes == null || !(userProfileRes?.status ?? false)) {
        Navigator.of(context).pop();
        return;
      }
      _isLoggedInUser = widget.userId == context.userId;
      if (_isLoggedInUser) {
        _tabController = TabController(length: 4, vsync: this);
      }
      setState(() {
        _userProfile = userProfileRes?.data;
        _userProfile?.userId = widget.userId;
        isLoading = false;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _loadMedia();
      _loadActivities();
    });
  }

  void _loadMedia() async {
    if (widget.userId == null) return;
    final MediaRes? mediaRes = await AppApi.instance.getDiaryMedia(
      context: context,
      userId: widget.userId!,
      start: 0,
    );
    if (!mounted) return;
    _mediaData = mediaRes?.data;
    setState(() {});
  }

  void _loadActivities() async {
    final ActivitiesRes? activitiesRes =
        await AppApi.instance.getActivities(context: context);
    if (!mounted) return;
    _activities = activitiesRes?.data ?? [];
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mediaController.dispose();
    super.dispose();
  }

  void _onEditPressed() async {
    if (_userProfile == null || !_isLoggedInUser) return;
    final updated = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            UpdateDiaryScreen(userProfile: _userProfile!),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
    if (!mounted || updated == null) return;
    setState(() => _userProfile = updated);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kThemeWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isLoggedInUser ? "My Diary" : "Diary",
          style: kTextStyle.copyWith(fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          if (_isLoggedInUser)
            IconButton(
              onPressed: _onEditPressed,
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      backgroundColor: kThemeAppBgColor,
      body: (isLoading)
          ? const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      (_isLoggedInUser)
                          ? DiaryProfileWidget(
                              userProfile: _userProfile,
                              isLoginUser: _isLoggedInUser,
                            )
                          : DiaryBuddyProfileWidget(
                              userProfile: _userProfile!,
                              photoCount: _mediaData?.postMedias?.length ?? 0,
                              videoCount: _mediaData?.videoMedias?.length ?? 0,
                            ),
                      (_isLoggedInUser)
                          ? Container(
                              width: double.infinity,
                              color: kThemeWhite,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15),
                              child: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                labelColor: kThemeTextColor,
                                indicatorColor: kThemeColor,
                                labelStyle: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                tabs: [
                                  const Tab(text: "Posts"),
                                  const Tab(text: "Medias"),
                                  const Tab(text: "About"),
                                  if (_isLoggedInUser)
                                    const Tab(text: "Activities"),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: kThemeWhite,
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 16),
                              child: Row(
                                // controller: _tabController,
                                // labelColor: kThemeTextColor,
                                // indicatorColor: Colors.transparent,
                                // labelPadding: EdgeInsets.zero,
                                // indicatorPadding: EdgeInsets.zero,
                                // onTap: (value) {
                                //   setState(() {
                                //     selectedIndex = value;
                                //   });
                                // },
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _tabController.index = 0;
                                        selectedIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      height: 24,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: selectedIndex == 0
                                            ? kThemePrimaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Posts",
                                        style: TextStyle(
                                            color: selectedIndex == 0
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12),
                                      )),
                                    ),
                                  ),
                                  kSpacerH,
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _tabController.index = 1;
                                        selectedIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      height: 24,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: selectedIndex == 1
                                            ? kThemePrimaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "Media",
                                        style: TextStyle(
                                            color: selectedIndex == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12),
                                      )),
                                    ),
                                  ),
                                  kSpacerH,
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _tabController.index = 2;
                                        selectedIndex = 2;
                                      });
                                    },
                                    child: Container(
                                      height: 24,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: selectedIndex == 2
                                            ? kThemePrimaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "About",
                                        style: TextStyle(
                                            color: selectedIndex == 2
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 12),
                                      )),
                                    ),
                                  ),
                                  if (_isLoggedInUser)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _tabController.index = 3;
                                          selectedIndex = 3;
                                        });
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: selectedIndex == 3
                                              ? kThemePrimaryColor
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "Activity",
                                          style: TextStyle(
                                              color: selectedIndex == 3
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 12),
                                        )),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            DiaryPostsWidget(userId: widget.userId),
                            DiaryMediaPage(
                              mediaData: _mediaData,
                              isBuddy: !_isLoggedInUser,
                              onTapImage: (imageList, selectedIndex,
                                  isProfileAndCover) {
                                onTapImageList(imageList, selectedIndex,
                                    isProfileAndCover);
                              },
                            ),
                            DiaryAboutPage(userProfile: _userProfile),
                            if (_isLoggedInUser)
                              DiaryActivityPage(list: _activities),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: selectedImageList != null,
                    child: Container(
                      color: Colors.black54,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: selectedImageList?.length,
                            itemBuilder: (context, index) {
                              MediaRawData? media = selectedImageList?[index];
                              return Image.network(
                                kTempImageHost + (media?.filePath ?? ''),
                                fit: BoxFit.fitWidth,
                              );
                            },
                          ),
                          Positioned(
                            right: 16,
                            top: 16,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    deletePhoto();
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: kThemeColor,
                                    size: 36,
                                  ),
                                ),
                                kSpacerH,
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageList = null;
                                      selectedImageIndex = 0;
                                      isProfileAndCover = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: kThemeColor,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class DiaryPostsWidget extends StatefulWidget {
  final int? userId;

  const DiaryPostsWidget({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<DiaryPostsWidget> createState() => _DiaryPostsWidgetState();
}

class _DiaryPostsWidgetState extends State<DiaryPostsWidget> {
  final RefreshController _postController =
      RefreshController(initialRefresh: false);
  List<PostModel?> _postList = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _init();
  }

  void _init() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    if (_postList.isEmpty && _userId != null) {
      _postController.requestRefresh();
    }
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _onDelete(PostModel post, int index) {
    AoLib.instance.showConfirmDialog(context,
        title: "Delete Post",
        content: "Are you sure you want to delete this post?",
        action: "Confirm", onActionPressed: () async {
      AoLib.instance.showLoading(context);
      final res = await AppApi.instance.deletePost(
        context: context,
        postId: post.id,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      AoLib.instance.showSnack(
          context: context, message: res?.msg ?? "Something went wrong.");
      if (res == null) return;
      setState(() => _postList = []);
      _init();
    });
  }

  void _loadDiaryPosts() async {
    if (_userId == null) return;
    final PostRes? postRes = await AppApi.instance.getDiaryPosts(
      context: context,
      userId: _userId!,
      start: 0,
    );
    if (!mounted) return;
    _postController.refreshCompleted();
    setState(() {
      _postList = postRes?.data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SmartRefresher(
        controller: _postController,
        onRefresh: _loadDiaryPosts,
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(waterDropColor: kThemeColor),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemBuilder: (context, index) {
            final PostModel? post = _postList[index];
            return PostItemWidget(
              post: post,
              onDeleteCallback: () => _onDelete(post!, index),
              onEditedCallback: (editedPost) {
                setState(() {
                  _postList[index] = editedPost;
                  _loadDiaryPosts();
                });
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: _postList.length,
        ),
      ),
    );
  }
}
