import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teatalk/model/post.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/widget/post_item.dart';

import '../../../../network/api/app_layer.dart';
import '../../../../provider/feed.dart';
import '../../../../util/ao_lib.dart';
import '../../../theme/color.dart';
import '../../../theme/dimens.dart';
import '../../../widget/app_btn.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(keepPage: true);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 17, horizontal: kAppGapDimens),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AppButtonWidget(
                  text: "FRESH FLASH",
                  fontColor: _index == 0 ? Colors.white : Colors.black,
                  background:
                      _index == 0 ? kThemePrimaryColor : kThemeUnselectedColor,
                  onPressed: () => _onPageChanged(0, fromPageView: false),
                ),
              ),
              Expanded(
                flex: 1,
                child: AppButtonWidget(
                  text: "MY ARENA",
                  fontColor: _index == 1 ? Colors.white : Colors.black,
                  background:
                      _index == 1 ? kThemePrimaryColor : kThemeUnselectedColor,
                  onPressed: () => _onPageChanged(1, fromPageView: false),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: _onPageChanged,
            children: const [
              FeedPostListWidget(),
              FeedPostListWidget(isMyArena: true),
            ],
          ),
        ),
      ],
    );
  }
}

class FeedPostListWidget extends StatefulWidget {
  final bool isMyArena;

  const FeedPostListWidget({
    Key? key,
    this.isMyArena = false,
  }) : super(key: key);

  @override
  State<FeedPostListWidget> createState() => _FeedPostListWidgetState();
}

class _FeedPostListWidgetState extends State<FeedPostListWidget>
    with AutomaticKeepAliveClientMixin {
  late bool isMyArena;
  late FeedProvider _feedProvider;
  final RefreshController _controller =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    isMyArena = widget.isMyArena;
    _feedProvider = context.read();
  }

  void _onRefresh({bool notifyEmpty = true}) async {
    final tmp = await _feedProvider.loadPosts(
        token: context.token,
        refresh: true,
        isMyArena: isMyArena,
        notifyEmpty: notifyEmpty);
    if (tmp == null) {
      _controller.loadFailed();
      return;
    }
    _controller.refreshCompleted();
  }

  void _onLoading() async {
    final tmp = await _feedProvider.loadPosts(
        token: context.token, isMyArena: isMyArena);
    if (tmp == null) {
      _controller.loadFailed();
      return;
    }
    if (tmp.isEmpty) {
      _controller.loadNoData();
      return;
    }
    _controller.loadComplete();
  }

  void _onDelete(PostModel post, int index) {
    // print('On Delete');
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
      _feedProvider.loadPosts(
          token: context.token,
          refresh: true,
          isMyArena: true,
          notifyEmpty: true);
      _feedProvider.loadPosts(
          token: context.token,
          refresh: true,
          isMyArena: false,
          notifyEmpty: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final FeedProvider feedProvider = context.watch();
    final List<PostModel> posts =
        isMyArena ? feedProvider.myArena : feedProvider.freshFlash;
    if (posts.isEmpty) return const CupertinoActivityIndicator();
    return SmartRefresher(
      controller: _controller,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(waterDropColor: kThemeColor),
      child: ListView.separated(
        controller: widget.isMyArena
            ? feedProvider.myAreaScrollController
            : feedProvider.freshFlashScrollController,
        padding: const EdgeInsets.only(top: 7, bottom: 10),
        itemBuilder: (context, index) {
          final PostModel post = posts[index];
          post.heroPrefix = isMyArena ? "myArena" : "freshFlash";
          return PostItemWidget(
            post: post,
            onDeleteCallback: () => _onDelete(post, index),
            onEditedCallback: (_) {
              _feedProvider.loadPosts(
                  token: context.token,
                  refresh: true,
                  isMyArena: true,
                  notifyEmpty: true);
              _feedProvider.loadPosts(
                  token: context.token,
                  refresh: true,
                  isMyArena: false,
                  notifyEmpty: true);
            },
            onCommentCallback: () {
              _feedProvider.loadPosts(
                  token: context.token,
                  refresh: true,
                  isMyArena: true,
                  notifyEmpty: true);
              _feedProvider.loadPosts(
                  token: context.token,
                  refresh: true,
                  isMyArena: false,
                  notifyEmpty: true);
            },
            onShareCallback: () {
              _feedProvider.loadPosts(
                  token: context.token,
                  refresh: true,
                  isMyArena: true,
                  notifyEmpty: true);
              _feedProvider.loadPosts(
                  token: context.token,
                  refresh: true,
                  isMyArena: false,
                  notifyEmpty: true);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: posts.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
