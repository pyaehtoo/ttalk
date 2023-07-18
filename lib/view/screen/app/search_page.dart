import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:teatalk/model/buddy.dart';
import 'package:teatalk/model/post.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/find_buddy_res.dart';
import 'package:teatalk/network/res/search_res.dart';
import 'package:teatalk/provider/feed.dart';
import 'package:teatalk/provider/search.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/screen/app/diary/diary.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/app_btn.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:teatalk/view/widget/post_item.dart';
import 'package:teatalk/view/widget/search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FeedProvider _feedProvider;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _feedProvider = context.read();
    _searchProvider = SearchProvider();
  }

  _loadCallbacks() {
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
  }

  @override
  void dispose() {
    super.dispose();
    _searchProvider.dispose();
  }

  // _search(String searchValue) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await AppApi.instance
  //       .getSearch(context: context, searchValue: searchValue)
  //       .then((value) {
  //     searchRes = value?.data;
  //     setState(() {
  //       isLoading = false;
  //       if (searchRes == null) {
  //         searchPageState = SearchPageState.resultNotFound;
  //       } else if ((searchRes?.accounts?.isEmpty ?? false) &&
  //           (searchRes?.posts?.isEmpty ?? false)) {
  //         searchPageState = SearchPageState.resultNotFound;
  //       } else {
  //         searchPageState = SearchPageState.resultFound;
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _searchProvider,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: double.infinity,
            color: ksearchBgColor,
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) => Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SearchTextFieldSection(
                        height: 66,
                        onSubmitted: (value) {
                          SearchProvider searchProvider =
                              Provider.of(context, listen: false);
                          searchProvider.search(
                              token: context.token.toString(),
                              searchValue: value);
                        },
                      ),
                      Visibility(
                        visible: false,
                        child: SearchHistory(
                          searchHistoryList: const [],
                          onRemoveAll: () {},
                          onRemoveAt: (index) {},
                        ),
                      ),
                      Visibility(
                        visible: provider.searchPageState ==
                            SearchPageState.resultNotFound,
                        child: const EmptyResultView(),
                      ),
                      Visibility(
                          visible: provider.searchPageState ==
                              SearchPageState.resultFound,
                          //visible: true,
                          child: Expanded(
                              child: ResultView(
                            accountList: provider.searchRes?.accounts ?? [],
                            postList: _searchProvider.searchRes?.posts ?? [],
                            loadPosts: () {
                              _loadCallbacks();
                            },
                          )))
                    ],
                  ),
                  Visibility(
                    visible: provider.isLoading,
                    child: Container(
                      color: Colors.black38,
                      child: const Center(
                        child: CircularProgressIndicator(color: kThemeColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultView extends StatefulWidget {
  final List<PostModel> postList;
  final List<AccountData> accountList;
  final Function loadPosts;
  const ResultView(
      {super.key,
      required this.postList,
      required this.accountList,
      required this.loadPosts});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _changeType(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onDelete(PostModel post, int index) {
    AoLib.instance.showConfirmDialog(context,
        title: "Delete Post",
        content: "Are you sure you want to delete this post?",
        action: "Delete", onActionPressed: () async {
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
      widget.loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchResultTypeSection(
            selectedIndex: selectedIndex,
            onChangeIndex: (index) {
              _changeType(index);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                      child: (widget.postList.isEmpty &&
                              widget.accountList.isEmpty &&
                              selectedIndex == 0)
                          ? const EmptyResultView()
                          : const SizedBox.shrink()),
                  // Post List
                  Visibility(
                    visible: selectedIndex == 0 || selectedIndex == 1,
                    child: (widget.postList.isEmpty && selectedIndex == 1)
                        ? const EmptyResultView()
                        : ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.postList.length,
                            itemBuilder: (context, index) {
                              return PostItemWidget(
                                post: widget.postList[index],
                                onDeleteCallback: () =>
                                    _onDelete(widget.postList[index], index),
                                onEditedCallback: (_) {
                                  widget.loadPosts();
                                },
                                onCommentCallback: () {
                                  widget.loadPosts();
                                },
                                onShareCallback: () {
                                  widget.loadPosts();
                                },
                              );
                            },
                          ),
                  ),

                  //People List
                  Visibility(
                    visible: selectedIndex == 0 || selectedIndex == 4,
                    child: (widget.accountList.isEmpty && selectedIndex == 4)
                        ? const EmptyResultView()
                        : ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.accountList.length,
                            itemBuilder: (context, index) {
                              AccountData acc = widget.accountList[index];
                              print(acc.toString());
                              return BuddySearchResultItem(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DiaryScreen(
                                          userId: widget.accountList[index]
                                              .getBuddyModel()
                                              .id)));
                                },
                                buddyModel:
                                    widget.accountList[index].getBuddyModel(),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuddySearchResultItem extends StatefulWidget {
  final Function onTap;
  final BuddyModel buddyModel;
  const BuddySearchResultItem({
    Key? key,
    required this.buddyModel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BuddySearchResultItem> createState() => _BuddySearchResultItemState();
}

class _BuddySearchResultItemState extends State<BuddySearchResultItem> {
  late BuddyModel _tempBuddyModel;
  @override
  void initState() {
    super.initState();
    _tempBuddyModel = widget.buddyModel;
  }

  void _addFriend() async {
    AoLib.instance.showLoading(context);
    final FindBuddyRes? findBuddyRes = await AppApi.instance
        .addBuddy(context: context, userId: _tempBuddyModel.id!);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (findBuddyRes?.status ?? false) {
      setState(() {
        _tempBuddyModel.relationshipStatus = "CANCEL";
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
        .cancelRequestedBuddy(context: context, userId: _tempBuddyModel.id!);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (findBuddyRes?.status ?? false) {
      setState(() {
        _tempBuddyModel.relationshipStatus = "NOT_FRIEND";
      });
    }
    AoLib.instance.showSnack(
      context: context,
      message: findBuddyRes?.msg ?? 'Something went wrong!',
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.buddyModel.id == context.userId;
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            AvatarWidget(
                profileUrl:
                    widget.buddyModel.profileModel?.profileImageUrl ?? '',
                size: 52),
            kSpacerH,
            Expanded(
              child: Text(
                widget.buddyModel.nickName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, color: Color(0xff474655)),
              ),
            ),
            Visibility(
              visible: _tempBuddyModel.isNotFriend() && !isMe,
              child: AppButtonWidget(
                width: 120,
                fontColor: Colors.white,
                text: "Add Buddy",
                onPressed: () {
                  _addFriend();
                },
              ),
            ),
            Visibility(
              visible: _tempBuddyModel.isCancel() && !isMe,
              child: AppButtonWidget(
                width: 120,
                background: Colors.grey,
                fontColor: Colors.white,
                text: "Cancel",
                onPressed: () {
                  _cancelRequested();
                },
              ),
            ),
            Visibility(
              visible: _tempBuddyModel.isFriend() && !isMe,
              child: AppButtonWidget(
                width: 120,
                fontColor: Colors.white,
                background: kThemePrimaryColor.withOpacity(0.5),
                text: "Go To Chat",
                onPressed: () {
                  AoLib.instance.showSnack(
                      context: context,
                      message: 'This feature is not available at the moment.');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchResultTypeSection extends StatelessWidget {
  const SearchResultTypeSection({
    super.key,
    required this.selectedIndex,
    required this.onChangeIndex,
  });

  final int selectedIndex;
  final Function(int) onChangeIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SearchResultTypeButton(
            isSelected: selectedIndex == 0,
            text: 'All',
            onTap: () {
              onChangeIndex(0);
            },
          ),
          SearchResultTypeButton(
            isSelected: selectedIndex == 1,
            text: 'Post',
            onTap: () {
              onChangeIndex(1);
            },
          ),
          SearchResultTypeButton(
            isSelected: selectedIndex == 2,
            text: 'Images',
            onTap: () {
              onChangeIndex(2);
            },
          ),
          SearchResultTypeButton(
            isSelected: selectedIndex == 3,
            text: 'Video',
            onTap: () {
              onChangeIndex(3);
            },
          ),
          SearchResultTypeButton(
            isSelected: selectedIndex == 4,
            text: 'People',
            onTap: () {
              onChangeIndex(4);
            },
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }
}

class SearchResultTypeButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function onTap;
  const SearchResultTypeButton(
      {super.key,
      required this.isSelected,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: (isSelected) ? kThemePrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.only(
          left: 15,
          top: 8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 15, color: (isSelected) ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Image.asset('assets/images/empty_box.png'),
        const Text(
          'No Data Found ! Check your keyword',
        )
      ],
    );
  }
}

class SearchHistory extends StatelessWidget {
  final List<String> searchHistoryList;
  final Function() onRemoveAll;
  final Function(int) onRemoveAt;
  const SearchHistory({
    super.key,
    required this.searchHistoryList,
    required this.onRemoveAll,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Search History'),
              GestureDetector(child: const Text('Clear All'))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(height: 0, color: Colors.grey),
          const SizedBox(
            height: 16,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return SearchHistoryItem(
                name: searchHistoryList[index],
                onRemove: () {},
              );
            },
          )
        ],
      ),
    );
  }
}

class SearchTextFieldSection extends StatelessWidget {
  final Function(String) onSubmitted;
  final double height;
  const SearchTextFieldSection({
    super.key,
    this.height = 80,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: height,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back)),
          ),
          Expanded(
              child: TextField(
            onSubmitted: (value) {
              onSubmitted(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(fontSize: 15),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              filled: true,
              fillColor: ksearchBgColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
            ),
          )),
          const SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}

class SearchHistoryItem extends StatelessWidget {
  final String name;
  final Function onRemove;
  const SearchHistoryItem({
    super.key,
    required this.name,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/search_history.png',
            width: 18,
            height: 18,
          ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 15, color: Color(0xff2f2e41)),
            ),
          ),
          GestureDetector(
            onTap: () {
              onRemove();
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Color(0xfff8ab4f), fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
