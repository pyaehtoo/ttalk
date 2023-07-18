import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teatalk/model/sticker_group_vo.dart';
import 'package:teatalk/model/sticker_vo.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/default_res.dart';
import 'package:teatalk/network/res/post_detail_res.dart';
import 'package:teatalk/network/res/reaction_res.dart';
import 'package:teatalk/network/res/sticker_per_post_res.dart';
import 'package:teatalk/network/res/sticker_res.dart';
import 'package:teatalk/provider/feed.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/log.dart';
import 'package:teatalk/view/screen/app/page/account.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:teatalk/view/widget/comment_item.dart';
import 'package:teatalk/view/widget/link_btn.dart';
import 'package:teatalk/view/widget/loading.dart';
import 'package:teatalk/view/widget/reaction_popup.dart';
import 'package:teatalk/view/widget/sticker_item.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../../../model/post.dart';
import '../../../network/res/comments_res.dart';
import '../../theme/color.dart';
import '../../widget/post_item.dart';

class PostDetailScreen extends StatefulWidget {
  final int? postId;
  final PostModel? post;
  final String action;
  final PostShareModel? postShare;
  final Function(PostModel)? onEditedCallback;
  final Function()? onDeletedCallback;
  final Function()? onCommentCallback;

  const PostDetailScreen({
    Key? key,
    this.postId,
    this.post,
    required this.action,
    this.onEditedCallback,
    this.onDeletedCallback,
    this.onCommentCallback,
    this.postShare,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostModel? _post;
  int? _postId;
  String? _action;
  int _commentCount = 0;
  int _stickerCount = 0;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  List<CommentsData> _comments = [];
  List<StickerPerPost> stickers = [];
  final List<StickerGroupVO> stickersListToPost = [];

  final FeedProvider _feedProvider = FeedProvider();
  bool isReply = false;
  bool isEdit = false;
  String oldComment = '';
  int replyCommentId = 0;
  int editCommentId = 0;
  String replyCommentOwnerName = '';
  bool isError = false;
  bool isCommentView = false;
  bool isStickerView = false;
  bool isStickerExpanded = false;
  int chooseStickerListIndex = 0;

  @override
  void initState() {
    super.initState();
    _action = widget.action;
    if (_action == 'comment') {
      isCommentView = true;
    }
    if (_action == 'sticker') {
      isStickerView = true;
      isStickerExpanded = true;
    }
    _postId = widget.postId ?? (widget.postShare?.id ?? widget.post?.id);
    _loadPostDetail();
    makeStickerShrink();
  }

  // void _loadPosts() {
  //   _feedProvider.loadPosts(context,
  //       refresh: true, isMyArena: true, notifyEmpty: true);
  //   _feedProvider.loadPosts(context,
  //       refresh: true, isMyArena: false, notifyEmpty: true);
  //   print('CALL PROVIDER');
  // }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();

    super.dispose();
  }

  Future _loadPostDetail() async {
    if (_postId == null) return;
    final PostDetailRes? postDetailRes =
        await AppApi.instance.getPostDetail(context: context, postId: _postId!);
    if (postDetailRes?.status == false) {
      AoLib.instance.showToast('Post has been deleted');
      isError = true;
      setState(() {});
      return Future.error('Post has been deleted');
    }
    final tmpPost = postDetailRes?.data;
    await _getStickersListToPost();

    if (!mounted) return;
    setState(() {
      _post = tmpPost ?? widget.post;
      _commentCount = _post?.commentCount ?? 0;
      _stickerCount = _post?.stickerCount ?? 0;
      print('post id =======> ${_post?.id}');
    });
    if (_commentCount > 0) {
      await _loadComments();
    }
    if (_stickerCount > 0) {
      await _loadStickers();
    }
    if (_action == "comment") {
      _commentFocusNode.requestFocus();
      _action = null;
    }
  }

  Future _loadStickers({List<StickerPerPost>? stickerList}) async {
    if (_postId == null) return;
    stickers.clear();

    if (stickerList == null) {
      final StickerPerPostRes? stickerRes = await AppApi.instance
          .getStickerPerPost(token: context.token!, postId: _postId ?? 0);
      if (!mounted) return;
      setState(() {
        stickers.addAll(stickerRes?.data ?? []);
      });

      print(stickers);
    } else {
      setState(() {
        stickers.addAll(stickerList);
      });
    }
  }

  Future<void> _getStickersListToPost() async {
    UserProfileModel? loggedInUser = await DbService.instance.getLoggedInUser();
    if (loggedInUser == null) {
      await AppApi.instance
          .getLoggedInUser(token: context.token!)
          .then((value) {
        loggedInUser = value?.data;
      });
    }

    String birthDateStr = loggedInUser?.birthDate ?? '';
    DateTime birthDate = DateTime.parse(birthDateStr);
    int age = AoLib.instance.calculateAge(birthDate);

    // int age = context.
    final StickerRes? stickerRes =
        await AppApi.instance.getStickerList(age: age);
    setState(() {
      stickersListToPost.addAll(stickerRes?.data ?? []);
      print(stickersListToPost);
    });
  }

  void _postSticker(StickerVO sticker) async {
    if (sticker.id != null) {
      await AppApi.instance
          .postSticker(
              token: context.token!,
              stickerId: sticker.id ?? 0,
              stickerUrl: sticker.imageUrl ?? '',
              postId: _postId ?? 0,
              stickerAmount: sticker.price ?? 0)
          .then((defaultRes) async {
        if (defaultRes?.status ?? false) {
          _loadStickers();
        } else {
          String message = defaultRes?.msg ?? '';
          AoLib.instance.showToast(message);
        }
      });
    }
  }

  Future _loadComments({List<CommentsData>? commentList}) async {
    if (_postId == null) return;
    _comments.clear();
    // setState(() {});
    if (commentList == null) {
      final CommentsRes? commentsRes =
          await AppApi.instance.getComments(context: context, postId: _postId!);
      if (!mounted) return;
      setState(() {
        _comments.addAll(commentsRes?.data ?? []);
      });
    } else {
      setState(() {
        _comments.addAll(commentList);
      });
    }

    print(commentList);
  }

  void _onEdited(PostModel editedPost) {
    widget.onEditedCallback?.call(editedPost);

    _refresh();
  }

  void _postComment() async {
    if (_postId == null) return;
    final String comment = _commentController.text.trim();
    if (comment.isEmpty) {
      _commentController.clear();
      _commentFocusNode.requestFocus();
      return;
    }

    if (isEdit && comment == oldComment) {
      _commentFocusNode.requestFocus();
      return;
    }

    AoLib.instance.dismissKeyboard();
    AoLib.instance.showLoading(context);
    final DefaultRes? defaultRes;
    if (isReply == true && replyCommentId != 0) {
      // Reply Comment
      await AppApi.instance
          .replyToComment(
              context: context,
              postId: _postId!,
              comment: comment,
              parentCommentId: replyCommentId)
          .then((defaultRes) {
        _checkReturnValue(defaultRes);
      });
    } else if (isEdit == true) {
      print('Edit to $editCommentId $comment');
      await AppApi.instance
          .editComment(
              token: context.token!, commentId: editCommentId, comment: comment)
          .then((defaultRes) => _checkReturnValue(defaultRes));
    } else {
      // Post Comment
      await AppApi.instance
          .addComment(context: context, postId: _postId!, comment: comment)
          .then((defaultRes) {
        _checkReturnValue(defaultRes);
      });
    }
  }

  void _checkReturnValue(DefaultRes? defaultRes) async {
    if (!mounted) return;
    Navigator.of(context).pop();
    if (defaultRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong!");
      return;
    }
    if (defaultRes.status ?? false) {
      _removeReplyState();
      _commentController.clear();
      _removeEditState();
      if (!isEdit) {
        setState(() {
          _commentCount++;
        });
      }

      // comment that is open reply comment view
      List<int> viewAllCommentList = [];
      print(viewAllCommentList);

      for (CommentsData comment in _comments) {
        if (comment.isViewAllComment ?? false) {
          viewAllCommentList.add(comment.id);
        }
      }
      await _loadComments();
      widget.onCommentCallback?.call();
      viewAllCommentList.map((id) {
        _viewAllComment(id);
      });
    }
  }

  void _reactComment(int commentId, bool isTap) async {
    String token = context.token!;
    ReactionData? reactionData;
    if (!isTap) {
      await showDialog(
        context: context,
        barrierColor: Colors.transparent,
        useSafeArea: false,
        builder: (c) => ReactionPopupWidget(
            onReactionSelected: (selectedReaction) {
              reactionData = selectedReaction;
              Navigator.pop(context);
            },
            postWidget: const SizedBox.shrink()),
      );
    }
    final CommentsRes? commentsRes = await AppApi.instance.reactToComment(
        token: token, commentId: commentId, react: reactionData);
    if (!mounted) return;
    if (commentsRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong!");
      return;
    }

    // // comment that is open reply comment view
    // List<int> viewAllCommentList = [];

    // for (CommentsData comment in _comments) {
    //   if (comment.isViewAllComment ?? false) {
    //     viewAllCommentList.add(comment.id);
    //   }
    // }
    // await _loadComments(commentList: commentsRes.data);
    // widget.onCommentCallback?.call();
    // viewAllCommentList.map((id) async {
    //   await _viewAllComment(id);
    // });
  }

  void _replyCommentState(int commentId, String userName) async {
    setState(() {
      isReply = true;
      isEdit = false;
      replyCommentId = commentId;
      replyCommentOwnerName = userName;
    });
  }

  void _editCommentState(int editId, String comment) async {
    setState(() {
      _commentFocusNode.requestFocus();
      isReply = false;
      isEdit = true;
      editCommentId = editId;
      replyCommentId = 0;
      replyCommentOwnerName = '';
      oldComment = comment;
      _commentController.text = AoLib.instance.htmlCharCodeToEmoji(comment);
      _commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: _commentController.text.length));
    });
  }

  void _removeReplyState() {
    setState(() {
      isReply = false;
      replyCommentId = 0;
    });
  }

  void _removeEditState() {
    setState(() {
      isEdit = false;
      editCommentId = 0;
      _commentController.clear();
    });
  }

  Future<void> _viewAllComment(int commentId) async {
    setState(() {
      for (CommentsData comment in _comments) {
        if (comment.id == commentId) {
          comment.isViewAllComment = true;
        }
      }
    });
  }

  void _deleteComment(int commentId) async {
    AoLib.instance.showConfirmDialog(context,
        content: 'Are you sure you want to delete this buzz?',
        crossAxisAlignment: CrossAxisAlignment.start,
        action: 'Delete', onActionPressed: () {
      AppApi.instance
          .deleteComment(token: context.token!, commentId: commentId)
          .then((defaultRes) async {
        // _checkReturnValue(defaultRes);
        if (defaultRes == null) {
          AoLib.instance
              .showSnack(context: context, message: "Something went wrong!");
          return;
        }
        if (defaultRes.status ?? false) {
          setState(() {
            _commentCount--;
          });

          // comment that is opne reply comment view
          List<int> viewAllCommentList = [];

          for (CommentsData comment in _comments) {
            if (comment.isViewAllComment ?? false) {
              viewAllCommentList.add(comment.id);
            }
          }
          await _loadComments();
          widget.onCommentCallback?.call();
          viewAllCommentList.map((id) async {
            _viewAllComment(id);
          });
        }
      });
    });
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() {
      _post = null;
      _comments.clear();
    });
    await _loadPostDetail();
    await _loadComments();
  }

  void onTapComment() {
    setState(() {
      isStickerView = false;
      isCommentView = true;
    });
  }

  void onTapSticker() {
    setState(() {
      isCommentView = false;
      isStickerView = true;
    });
  }

  void makeStickerExpanded() {
    setState(() {
      isStickerExpanded = true;
    });
  }

  void makeStickerShrink() {
    setState(() {
      isStickerExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: .4,
        backgroundColor: kThemeWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: kThemeWhite,
      body: (stickersListToPost == null || stickersListToPost.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      makeStickerShrink();
                    },
                    child: Container(
                      color: kThemeAppBgColor,
                      width: double.infinity,
                      height: double.infinity,
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.only(top: 20, bottom: 80),
                          children: [
                            AnimatedCrossFade(
                              firstChild: const SizedBox(),
                              secondChild: _post == null
                                  ? const SizedBox()
                                  : PostItemWidget(
                                      post: _post,
                                      fromDetail: true,
                                      commentCount: _commentCount,
                                      onCommentCallback: () {
                                        onTapComment();
                                        _commentFocusNode.requestFocus();
                                      },
                                      onStickerCallback: () {
                                        onTapSticker();
                                      },
                                      onEditedCallback: _onEdited,
                                      onDeleteCallback: () =>
                                          Navigator.of(context)
                                              .pop("delete_me"),
                                      margin: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        bottom: 0,
                                      ),
                                    ),
                              crossFadeState: _post == null
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: kThemeChangeDuration,
                            ),
                            Visibility(
                              visible: (_comments.isNotEmpty && isCommentView),
                              child: Container(
                                width: double.infinity,
                                color: kThemeWhite,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Divider(
                                          height: 0, color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        "$_commentCount ${(_commentCount > 1) ? 'buzzes' : 'buzz'}",
                                        style: kTextStyle.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13, horizontal: 15),
                                      itemCount: _comments.length,
                                      itemBuilder: (c, i) => CommentItemWidget(
                                        commentsData: _comments[i],
                                        postId: _postId ?? 0,
                                        isRelyFocused:
                                            _comments[i].id == replyCommentId,
                                        onLikeCallback: (commentId, isTap) {
                                          _reactComment(commentId, isTap);
                                        },
                                        onReplyCallback: (commentId, userName) {
                                          _replyCommentState(
                                              commentId, userName);
                                        },
                                        onViewAllCallback: (commentId) {
                                          _viewAllComment(commentId);
                                        },
                                        onDeletedCallback: (commentId) {
                                          _deleteComment(commentId);
                                        },
                                        onEditCallback: (commentId, comment) {
                                          _editCommentState(commentId, comment);
                                        },
                                        isMyOwnPost:
                                            _post?.postBy == context.userId,
                                      ),
                                    ),
                                    SizedBox(
                                      height: (isStickerExpanded) ? 230 : 36,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (stickers.isNotEmpty && isStickerView),
                              child: Container(
                                width: double.infinity,
                                color: kThemeWhite,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Divider(
                                          height: 0, color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        "$_stickerCount ${(_stickerCount > 1) ? 'Stickers' : 'Sticker'}",
                                        style: kTextStyle.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 36,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13, horizontal: 15),
                                      itemCount: stickers.length,
                                      itemBuilder: (c, index) => StickerItem(
                                        sticker: stickers[index],
                                      ),
                                    ),
                                    SizedBox(
                                      height: (isStickerExpanded) ? 230 : 36,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (isStickerExpanded) ? 220 : 36,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isStickerView,
                  child: SafeArea(
                      child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      height: isStickerExpanded ? 230 : 36,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 36,
                            color: kThemePrimaryColor,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: stickersListToPost.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    makeStickerExpanded();
                                    setState(() {
                                      chooseStickerListIndex = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            (chooseStickerListIndex == index)
                                                ? const Border(
                                                    bottom: BorderSide(
                                                        color: Colors.white,
                                                        width: 2))
                                                : null),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      stickersListToPost[index].name ?? '',
                                      style: kTextStyle.copyWith(
                                          color: Colors.white,
                                          fontWeight:
                                              (chooseStickerListIndex == index)
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                          fontSize:
                                              (chooseStickerListIndex == index)
                                                  ? 15
                                                  : 14),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: isStickerExpanded,
                            child: Container(
                              height: 193,
                              width: double.infinity,
                              color: Colors.white,
                              child: GridView.builder(
                                itemCount:
                                    stickersListToPost[chooseStickerListIndex]
                                            .stickers
                                            ?.length ??
                                        0,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4,
                                ),
                                itemBuilder: (context, index) {
                                  StickerVO? sticker =
                                      stickersListToPost[chooseStickerListIndex]
                                          .stickers?[index];
                                  return GestureDetector(
                                    onTap: () {
                                      _postSticker(sticker ?? StickerVO());
                                    },
                                    child: Container(
                                      height: 85,
                                      width: 60,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            sticker?.imageUrl ?? '',
                                            width: 60,
                                            height: 60,
                                          ),
                                          IceCubeCount(
                                            count: sticker?.price?.toString() ??
                                                '',
                                            fontSize: 10,
                                            iceCubeSize: 14,
                                            midPadding: 2,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
                Visibility(
                  visible: isCommentView,
                  child: SafeArea(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kThemeWhite,
                          border: Border(
                            top: BorderSide(
                                color: Colors.black.withOpacity(0.1)),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Visibility(
                              visible: isEdit || isReply,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(isEdit ? 'Edit Comment' : 'Reply'),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      isEdit
                                          ? _removeEditState()
                                          : _removeReplyState();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                AvatarWidget(
                                  profileUrl: context.userProfileImage,
                                  size: 50,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    focusNode: _commentFocusNode,
                                    maxLines: 2,
                                    minLines: 1,
                                    textInputAction: TextInputAction.newline,
                                    decoration: InputDecoration(
                                      hintText: isReply
                                          ? "Reply To @$replyCommentOwnerName"
                                          : "Enter Your Buzz",
                                      hintStyle: kTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: _postComment,
                                  child: Text(
                                    "Post",
                                    style: kTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: kThemeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(),
                  secondChild: const LoadingWidget(),
                  crossFadeState: _post == null || stickersListToPost.isEmpty
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: kThemeChangeDuration,
                ),
              ],
            ),
    );
  }
}
