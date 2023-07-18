import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/post.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/default_res.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/constant.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/post_privacy.dart';
import 'package:teatalk/view/screen/app/create_post.dart';
import 'package:teatalk/view/screen/app/diary/diary.dart';
import 'package:teatalk/view/screen/app/post_detail.dart';
import 'package:teatalk/view/screen/app/post_reacts.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:teatalk/view/widget/choose_privacy_bottom_sheet.dart';
import 'package:teatalk/view/widget/post_privacy_status.dart';
import 'package:teatalk/view/widget/reaction_popup.dart';
import 'package:teatalk/view/widget/video_item.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/res/media_res.dart';
import '../../network/res/reaction_res.dart';
import 'gallery_view_wrapper.dart';

class PostItemWidget extends StatefulWidget {
  final PostModel? post;
  final bool fromDetail;
  final EdgeInsets? margin;
  final bool shareContent;
  final bool fromShareDilog;
  final int? commentCount;
  final Function(PostModel)? onEditedCallback;
  final Function()? onDeleteCallback;
  final Function()? onCommentCallback;
  final Function()? onShareCallback;
  final Function()? onStickerCallback;

  const PostItemWidget({
    Key? key,
    required this.post,
    this.commentCount,
    this.fromDetail = false,
    this.margin,
    this.shareContent = false,
    this.fromShareDilog = false,
    this.onDeleteCallback,
    this.onEditedCallback,
    this.onCommentCallback,
    this.onShareCallback,
    this.onStickerCallback,
  }) : super(key: key);

  @override
  State<PostItemWidget> createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> {
  final List<PostImageModel> _postImages = [];
  final List<PostImageModel> _sharedPostImages = [];
  String? _postContent;
  late DateTime _create;
  PostPrivacy? _privacy;
  PostShareModel? _sharedPost;
  DateTime? _shareCreated;
  late PostModel _post;
  int _reactByMe = 0;
  int _reactionCount = 0;
  String reactType = '';

  @override
  void initState() {
    super.initState();
    if (widget.post == null) return;
    _post = widget.post!;
    if (_post.reactByMe != 0) {
      reactType = _post.reacts
              ?.firstWhere(
                (element) => element.reacterId == context.userId,
              )
              .react ??
          '';
    }

    _init();
  }

  void _init() async {
    _reactByMe = _post.reactByMe;
    _postContent = _post.content;
    _reactionCount = _post.reactCount;
    _create = DateTime.parse(_post.createdAt!);
    _privacy = _post.privacy.getPrivacy();
    _sharedPost = _post.share;
    _shareCreated = DateTime.tryParse(_sharedPost?.createdAt ?? '');
    _postImages.clear();
    for (final element in (_post.postImages ?? [])) {
      element.heroPrefix = _post.heroPrefix;
      _postImages.add(element);
    }
    _sharedPostImages.clear();
    for (final element in (_sharedPost?.postImages ?? [])) {
      element.heroPrefix = _post.heroPrefix;
      _sharedPostImages.add(element);
    }
  }

  void _showReaction() async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (c) => ReactionPopupWidget(
        onReactionSelected: _onReactionSelected,
        postWidget: widget.fromDetail
            ? const SizedBox()
            : AbsorbPointer(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kThemeWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (widget.fromDetail) return;
                              _gotoDetail("view");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  AvatarWidget(
                                    profileUrl: _post
                                        .postByData?.profile?.profileImageUrl,
                                    size: 55,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          _post.postByData?.nickName ?? '-',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Timeago(
                                              builder: (c, s) {
                                                return Text(
                                                  "$s  |",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    color: kThemeSecTextColor
                                                        .withOpacity(0.7),
                                                  ),
                                                );
                                              },
                                              locale: 'en_short',
                                              date: _create,
                                            ),
                                            const SizedBox(width: 4),
                                            Container(
                                              width: 15,
                                              height: 15,
                                              padding:
                                                  const EdgeInsets.only(top: 1),
                                              child: SvgPicture.asset(
                                                _privacy?.svgPath ??
                                                    'assets/images/ic_world.svg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PostItemContentTextWidget(
                              content: _postContent,
                              expanded: widget.fromDetail),
                          PostItemImagesWidget(
                            images: _postImages,
                            onImageClick: (int index) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GalleryPhotoViewWrapper(
                                    postImageList: _postImages,
                                    initialIndex: index,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (_sharedPost != null) ...[
                            PostItemWidget(
                              post: _post,
                              shareContent: true,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                            ),
                          ],
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: Divider(height: 0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _onReactionSelected(ReactionData reaction) async {
    // Dismiss reaction popup
    Navigator.of(context).pop();
    HapticFeedback.lightImpact();
    if (!mounted) return;
    final DefaultRes? defaultRes = await AppApi.instance
        .reactToPost(context: context, postId: _post.id, react: reaction);
    if (!mounted) return;
    if (defaultRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong");
      return;
    }
    final String? msg = defaultRes.msg;
    if ((defaultRes.status ?? false) && msg != null) {
      final bool reacted = msg.contains("Reacted");
      setState(() {
        if (_reactByMe == 1) {
          if (!reacted) _reactionCount--;
        } else {
          if (reacted) _reactionCount++;
        }
        _reactByMe = reacted ? 1 : 0;
        reactType = (_reactByMe != 0) ? reaction.name : '';
      });
    }
  }

  void _gotoDetail(String action, {bool shareDetail = false}) async {
    if (shareDetail) {
      final status = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PostDetailScreen(
              post: _post,
              postShare: _sharedPost,
              action: action,
              onEditedCallback: (_) {
                _post = _;
                _init();
                setState(() {});
                widget.onEditedCallback?.call(_post);
              },
              onDeletedCallback: widget.onDeleteCallback,
              onCommentCallback: () {}),
        ),
      );
      if (status == "delete_me") {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        widget.onDeleteCallback?.call();
      }
      return;
    }

    final status = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          post: _post,
          action: action,
          onEditedCallback: (_) {
            _post = _;
            _init();
            setState(() {});
            widget.onEditedCallback?.call(_post);
          },
          onDeletedCallback: widget.onDeleteCallback,
          onCommentCallback: () {
            widget.onCommentCallback?.call();
          },
        ),
      ),
    );
    if (status == "delete_me") {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      widget.onDeleteCallback?.call();
    }
  }

  void _goToDiary(BuildContext context, int? userId) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DiaryScreen(userId: userId),
      ),
    );
  }

  void _editPost() async {
    final postModel = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(
          postModel: _post,
          onEditedCallback: (postModel) {
            // if (postModel != null) {
            //   _post = postModel;
            //   _init();
            //   setState(() {});
            //   widget.onEditedCallback?.call(postModel);
            // }
          },
        ),
      ),
    );
    if (postModel != null) {
      _post = postModel;
      _init();
      setState(() {});
      widget.onEditedCallback?.call(postModel);
    }
  }

  String getReactImagePath() {
    if (_reactByMe != 0) {
      //PostReactModel myReact = _post.reacts?.where((element) => element.id == context.userId,).first ?? PostReactModel(0, reactableType, reactableId, reacterId, react, createdAt, updatedAt, reacter);
      String upperCaseType = reactType.toUpperCase();
      if (upperCaseType == 'HAPPY') {
        return 'assets/images/ic_react_happy.png';
      } else if (upperCaseType == 'LOVE') {
        return 'assets/images/ic_react_love.png';
      } else if (upperCaseType == 'HAHA') {
        return 'assets/images/ic_react_haha.png';
      } else if (upperCaseType == 'SAD') {
        return 'assets/images/ic_react_sad.png';
      } else if (upperCaseType == 'WOW') {
        return 'assets/images/ic_react_wow.png';
      } else if (upperCaseType == 'ANGRY') {
        return 'assets/images/ic_react_angry.png';
      }

      return 'assets/images/ic_react_update.svg';
    }

    return 'assets/images/ic_react_update.svg';
  }

  Future<bool> _showShareDialog(
      UserProfileModel userProfile, PostModel _post) async {
    TextEditingController _contentController = TextEditingController();
    bool isLoading = false;
    bool isShared = false;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 15),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Share Post',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Graphie'),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 8),
                              child: AvatarWidget(
                                profileUrl: userProfile.profileImageUrl,
                                size: 45,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      userProfile.nickName ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _changePrivacy,
                                    child: const PostPrivacyStatusWidget(
                                      width: 90,
                                      logoSize: 16,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 17,
                          ),
                          child: TextField(
                            controller: _contentController,
                            cursorColor: kThemeTextColor,
                            style: kTextStyle.copyWith(
                              fontSize: 17,
                              color: kThemeSecTextColor,
                            ),
                            minLines: 1,
                            maxLines: 20,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Write Something here',
                              border: kTfNoBorder,
                              focusedBorder: kTfNoBorder,
                              enabledBorder: kTfNoBorder,
                              errorBorder: kTfNoBorder,
                              hintStyle: kTextStyle.copyWith(
                                fontSize: 17,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: PostItemWidget(
                            post: _post,
                            fromShareDilog: true,
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // TODO
                            setState(() {
                              isLoading = true;
                            });
                            DefaultRes? res = await AppApi.instance.sharePost(
                                context: context,
                                postId: (_post.parentId != null)
                                    ? _post.parentId!
                                    : _post.id,
                                content: _contentController.text);
                            if (res == null) {
                              AoLib.instance.showSnack(
                                  context: context,
                                  message: "Something went wrong");
                              setState(() {
                                isLoading = false;
                              });
                              // Dismiss loading
                              Navigator.of(context).pop();
                              return;
                            }

                            AoLib.instance.showSnack(
                                context: context,
                                message: "Successfully posted!");

                            if (!mounted) return;
                            Navigator.of(context).pop();
                            isShared = true;
                          },
                          child: Container(
                            height: 46,
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                            decoration: BoxDecoration(
                                color: kThemePrimaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Center(
                              child: Text(
                                'Share',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 15,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset(
                        'assets/images/ic_remove.svg',
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: Positioned.fill(
                        child: Container(
                      color: Colors.black45,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )),
                  )
                ],
              )),
        );
      },
    );

    return Future.value(isShared);
  }

  void _changePrivacy() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: kThemeBgColor,
      isScrollControlled: true,
      builder: (c) => const ChoosePrivacyBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = context.watch();
    final List<ReactionData> reactions = appProvider.reactions;
    final UserProvider provider = context.watch();
    final UserProfileModel? userProfile = provider.userProfile;
    if (widget.post == null) return const SizedBox();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: kThemeWhite,
              border: (widget.shareContent || widget.fromShareDilog) &&
                      !(_sharedPost != null && widget.fromShareDilog)
                  ? Border.all(color: Colors.grey.withOpacity(0.3))
                  : null,
              boxShadow: (widget.fromShareDilog)
                  ? [
                      BoxShadow(
                          // blurStyle: BlurStyle.inner,
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 30,
                          offset: const Offset(0, 2))
                    ]
                  : null),
          margin: widget.margin ??
              const EdgeInsets.only(
                left: kAppGapDimens,
                right: kAppGapDimens,
                bottom: 15,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.shareContent) ...[
                InkWell(
                  onTap: () {
                    if (widget.fromDetail) return;
                    _gotoDetail("view");
                  },
                  child: Visibility(
                    visible: !(_sharedPost != null && widget.fromShareDilog),
                    child: Padding(
                      padding: (_sharedPost != null && widget.fromShareDilog)
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10, right: 5),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _goToDiary(context, _post.postByData?.id);
                            },
                            child: AvatarWidget(
                              profileUrl:
                                  _post.postByData?.profile?.profileImageUrl,
                              size: 55,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                InkWell(
                                  onTap: () {
                                    _goToDiary(context, _post.postByData?.id);
                                  },
                                  child: Text(
                                    _post.postByData?.nickName ?? '-',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Timeago(
                                      builder: (c, s) {
                                        String time = '';
                                        if (s.contains('~')) {
                                          time = s.replaceAll('~', '');
                                        } else {
                                          time = s;
                                        }
                                        return Text(
                                          "$time  |",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kTextStyle.copyWith(
                                            fontSize: 12,
                                            color: kThemeSecTextColor
                                                .withOpacity(0.7),
                                          ),
                                        );
                                      },
                                      locale: 'en_short',
                                      date: _create,
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      padding: const EdgeInsets.only(top: 1),
                                      child: SvgPicture.asset(
                                        _privacy?.svgPath ??
                                            'assets/images/ic_world.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (_post.postBy == context.userId &&
                              !widget.fromShareDilog)
                            PopupMenuButton(
                              padding:
                                  const EdgeInsets.only(bottom: 10, left: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              position: PopupMenuPosition.over,
                              icon:
                                  SvgPicture.asset("assets/images/ic_more.svg"),
                              onSelected: (_) {
                                final String action = _;
                                if (action == "edit") {
                                  _editPost();
                                } else if (action == "delete") {
                                  widget.onDeleteCallback?.call();
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                  const PopupMenuItem(
                                    value: 'edit',
                                    height: 27,
                                    child: ListTile(
                                        title: Text("Edit", style: kTextStyle)),
                                  ),
                                  const PopupMenuDivider(),
                                  PopupMenuItem(
                                    value: 'delete',
                                    height: 27,
                                    child: ListTile(
                                      title: Text(
                                        "Delete",
                                        style: kTextStyle.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !(_sharedPost != null && widget.fromShareDilog),
                  child: PostItemContentTextWidget(
                      content: _postContent, expanded: widget.fromDetail),
                ),
                PostItemImagesWidget(
                  images: _postImages,
                  onImageClick: (int index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          postImageList: _postImages,
                          initialIndex: index,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  },
                ),
                if (_sharedPost != null) ...[
                  PostItemWidget(
                    post: _post,
                    shareContent: true,
                    margin: (_sharedPost != null && widget.fromShareDilog)
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.only(left: 10, right: 10, top: 5),
                  ),
                ],
                Visibility(
                    visible: (_sharedPost == null && _post.parentId != null),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 225,
                      decoration: BoxDecoration(
                          color: kThemeUnselectedColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Text('This content has been deleted'),
                      ),
                    )),
                Visibility(
                  visible: !widget.fromShareDilog,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Divider(height: 0, color: Colors.grey),
                  ),
                ),
                Visibility(
                  visible: !widget.fromShareDilog,
                  child: Row(
                    children: [
                      PostFooterItemWidget(
                        svgPath: getReactImagePath(),
                        // svgPath: 'assets/images/ic_react.svg',
                        isReactItem: true,
                        text: _reactionCount.toString(),
                        isActive: _reactByMe != 0,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PostReactScreen(postId: _post.id),
                            ),
                          );
                        },
                        onLongPressed: _showReaction,
                      ),
                      PostFooterItemWidget(
                        svgPath: 'assets/images/ic_comment.svg',
                        text: widget.commentCount?.toString() ??
                            _post.commentCount.toString(),
                        isActive: false,
                        onPressed: () {
                          if (widget.fromDetail) {
                            widget.onCommentCallback?.call();
                            return;
                          }
                          _gotoDetail("comment");
                        },
                      ),
                      PostFooterItemWidget(
                        svgPath: 'assets/images/ic_sticker.svg',
                        text: _post.stickerCount?.toString() ?? '0',
                        isActive: false,
                        onPressed: () {
                          if (widget.fromDetail) {
                            widget.onStickerCallback?.call();
                            return;
                          }
                          ;
                          _gotoDetail("sticker");
                        },
                      ),
                      PostFooterItemWidget(
                        svgPath: 'assets/images/ic_share.svg',
                        text: _post.shareCount?.toString() ?? '0',
                        isActive: false,
                        onPressed: () async {
                          // if (widget.fromDetail) return;
                          await _showShareDialog(userProfile!, _post)
                              .then((value) {
                                if(value){

                            widget.onShareCallback?.call();
                                }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ] else if (_sharedPost != null) ...[
                InkWell(
                  onTap: () {
                    if (widget.fromDetail) return;
                    _gotoDetail("view", shareDetail: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _goToDiary(context, _sharedPost?.postByData?.id);
                          },
                          child: AvatarWidget(
                            profileUrl: _sharedPost!
                                .postByData?.profile?.profileImageUrl,
                            size: 55,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              GestureDetector(
                                onTap: () {
                                  _goToDiary(
                                      context, _sharedPost?.postByData?.id);
                                },
                                child: Text(
                                  _sharedPost!.postByData?.nickName ?? '-',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Timeago(
                                    builder: (c, s) {
                                      String time = '';
                                      if (s.contains('~')) {
                                        time = s.replaceAll('~', '');
                                      } else {
                                        time = s;
                                      }
                                      return Text(
                                        "$time  |",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyle.copyWith(
                                          fontSize: 12,
                                          color: kThemeSecTextColor
                                              .withOpacity(0.7),
                                        ),
                                      );
                                    },
                                    locale: 'en_short',
                                    date: _shareCreated!,
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    padding: const EdgeInsets.only(top: 1),
                                    child: SvgPicture.asset(
                                      _privacy?.svgPath ??
                                          'assets/images/ic_world.svg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PostItemContentTextWidget(
                  content: _sharedPost!.content,
                  expanded: widget.fromDetail,
                ),
                PostItemImagesWidget(
                  images: _sharedPostImages,
                  onImageClick: (int index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          postImageList: _sharedPostImages,
                          initialIndex: index,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  },
                ),
                kSpacerV,
              ],
            ],
          ),
        ),
        Visibility(
          // visible: (!widget.shareContent),
          visible: false,
          child: Container(
            width: double.infinity,
            height: 65,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 60),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: kThemeWhite,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...reactions
                    .map(
                      (_) => ReactionItemWidget(
                        reaction: _,
                        onSelected: () => _onReactionSelected(_),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PostItemContentTextWidget extends StatefulWidget {
  final bool expanded;
  final String? content;
  final bool? isPaddingFalse;
  final TextStyle textStyle;
  final bool isReply;
  final Color bgColor;

  const PostItemContentTextWidget(
      {Key? key,
      required this.content,
      this.expanded = false,
      this.isPaddingFalse = false,
      this.textStyle = const TextStyle(
          color: Color(0xff2F2E41),
          fontFamily: 'Graphie',
          fontSize: 15,
          height: 1.7),
      this.isReply = false,
      this.bgColor = kThemeWhite})
      : super(key: key);

  @override
  State<PostItemContentTextWidget> createState() =>
      _PostItemContentTextWidgetState();
}

class _PostItemContentTextWidgetState extends State<PostItemContentTextWidget> {
  late bool _expanded;

  late TextPainter _textPainter;

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    final textContent =
        TextSpan(text: AoLib.instance.htmlCharCodeToEmoji(widget.content));
    _textPainter = TextPainter(
      maxLines: 3,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: textContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content.isNullOrEmpty) return const SizedBox();
    final Size size = MediaQuery.of(context).size;
    // Checking device width with padding space
    _textPainter.layout(maxWidth: (size.width) - kAppGapDimens * 2 - 15 * 2);
    final bool seeMore = _textPainter.didExceedMaxLines;
    final TextStyle textStyle = widget.textStyle;
    return Padding(
      padding: (widget.isPaddingFalse ?? false)
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (seeMore) ...[
            AnimatedCrossFade(
              firstChild: InkWell(
                // onTap: () => setState(() => _expanded = false),
                child: Linkify(
                  text: AoLib.instance.htmlCharCodeToEmoji(widget.content),
                  onOpen: (link) async {
                    await AoLib.instance.openUrl(link.url);
                  },
                  style: textStyle,
                  linkStyle: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              secondChild: Stack(
                // alignment: Alignment.bottomRight,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Linkify(
                      text: AoLib.instance.htmlCharCodeToEmoji(widget.content),
                      onOpen: (link) async {
                        await AoLib.instance.openUrl(link.url);
                      },
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 15,
                    child: Container(
                      color: widget.bgColor,
                      // width: 100,
                      padding: EdgeInsets.only(
                          left: 3,
                          right: 3,
                          top: 5,
                          bottom: widget.isReply ? 0 : 5),
                      child: Text(
                        "....................",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 3,
                          right: 3,
                          // top: 5,
                          bottom: widget.isReply ? 0 : 5),
                      color: widget.bgColor,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _expanded = true);
                        },
                        child: Text(
                          "See More",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.copyWith(
                              color: widget.isReply
                                  ? Colors.white
                                  : kThemePrimaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ] else ...[
            
            Linkify(
              text: AoLib.instance.htmlCharCodeToEmoji(widget.content),
              onOpen: (link) async {
                await AoLib.instance.openUrl(link.url);
              },
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ],
        ],
      ),
    );
  }
}

class PostItemImagesWidget extends StatelessWidget {
  final double height;
  final List<PostImageModel> images;
  final List<XFile>? fileImages;
  final Function(int)? onDelete;
  final Function(int) onImageClick;

  const PostItemImagesWidget({
    Key? key,
    required this.images,
    this.height = 250,
    this.fileImages,
    this.onDelete,
    required this.onImageClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showDelete = onDelete != null;
    Widget child = const SizedBox();

    if (images.isNotEmpty) {
      switch (images.length) {
        case 0:
          child = const SizedBox();
          break;
        case 1:
          child = CachedPostImageWidget(
            image: images.first,
            height: height,
            onPressed: () => onImageClick.call(0),
            onDeleted: () => onDelete?.call(0),
            showDelete: showDelete,
          );
          break;
        case 2:
          child = Row(
            children: [
              Expanded(
                flex: 1,
                child: CachedPostImageWidget(
                  image: images.first,
                  height: height,
                  onPressed: () => onImageClick.call(0),
                  onDeleted: () => onDelete?.call(0),
                  showDelete: showDelete,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: CachedPostImageWidget(
                  image: images[1],
                  height: height,
                  onPressed: () => onImageClick.call(1),
                  onDeleted: () => onDelete?.call(1),
                  showDelete: showDelete,
                ),
              ),
            ],
          );
          break;
        case 3:
          child = Row(
            children: [
              Expanded(
                flex: 1,
                child: CachedPostImageWidget(
                  image: images.first,
                  height: height,
                  onPressed: () => onImageClick.call(0),
                  onDeleted: () => onDelete?.call(0),
                  showDelete: showDelete,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CachedPostImageWidget(
                          image: images[1],
                          height: (height / 2) - 2.5,
                          onPressed: () => onImageClick.call(1),
                          onDeleted: () => onDelete?.call(1),
                          showDelete: showDelete,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        flex: 1,
                        child: CachedPostImageWidget(
                          image: images[2],
                          height: (height / 2) - 2.5,
                          onPressed: () => onImageClick.call(2),
                          onDeleted: () => onDelete?.call(2),
                          showDelete: showDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
          break;
        default:
          child = Row(
            children: [
              Expanded(
                flex: 1,
                child: CachedPostImageWidget(
                  image: images.first,
                  height: height,
                  onPressed: () => onImageClick.call(0),
                  onDeleted: () => onDelete?.call(0),
                  showDelete: showDelete,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CachedPostImageWidget(
                          image: images[1],
                          height: (height / 2) - 2.5,
                          onPressed: () => onImageClick.call(1),
                          onDeleted: () => onDelete?.call(1),
                          showDelete: showDelete,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        flex: 1,
                        child: CachedPostImageWidget(
                          image: images[2],
                          height: (height / 2) - 2.5,
                          showViewMore: true,
                          restImages: images.length - 2,
                          onPressed: () => onImageClick.call(2),
                          onDeleted: () => onDelete?.call(2),
                          showDelete: showDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
      }
    } else if (fileImages != null && fileImages!.isNotEmpty) {
      switch (fileImages!.length) {
        case 0:
          child = const SizedBox();
          break;
        case 1:
          child = FileImageWidget(
            file: fileImages!.first,
            height: height,
            onDelete: () => onDelete!(0),
            onPressed: () => onImageClick.call(0),
          );
          break;
        case 2:
          child = Row(
            children: [
              Expanded(
                flex: 1,
                child: FileImageWidget(
                  file: fileImages![0],
                  height: height,
                  onDelete: () => onDelete!(0),
                  onPressed: () => onImageClick.call(0),
                ),
              ),
              kSpacerH,
              Expanded(
                flex: 1,
                child: FileImageWidget(
                  file: fileImages![1],
                  height: height,
                  onDelete: () => onDelete!(1),
                  onPressed: () => onImageClick.call(1),
                ),
              ),
            ],
          );
          break;
        case 3:
          child = Row(
            children: [
              Expanded(
                flex: 1,
                child: FileImageWidget(
                  file: fileImages![0],
                  height: height,
                  onDelete: () => onDelete!(0),
                  onPressed: () => onImageClick.call(0),
                ),
              ),
              kSpacerH,
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FileImageWidget(
                          file: fileImages![1],
                          height: (height / 2) - 5,
                          onDelete: () => onDelete!(1),
                          onPressed: () => onImageClick.call(1),
                        ),
                      ),
                      kSpacerV,
                      Expanded(
                        flex: 1,
                        child: FileImageWidget(
                          file: fileImages![2],
                          height: (height / 2) - 5,
                          onDelete: () => onDelete!(2),
                          onPressed: () => onImageClick.call(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
          break;
        default:
          child = Row(
            children: [
              Expanded(
                flex: 1,
                child: FileImageWidget(
                  file: fileImages![0],
                  height: height,
                  onDelete: () => onDelete!(0),
                  onPressed: () => onImageClick.call(0),
                ),
              ),
              kSpacerH,
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: height,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FileImageWidget(
                          file: fileImages![1],
                          height: (height / 2) - 5,
                          onDelete: () => onDelete!(1),
                          onPressed: () => onImageClick.call(1),
                        ),
                      ),
                      kSpacerV,
                      Expanded(
                        flex: 1,
                        child: FileImageWidget(
                          file: fileImages![2],
                          onDelete: () => onDelete!(2),
                          height: (height / 2) - 5,
                          showViewMore: true,
                          restImages: fileImages!.length - 2,
                          onPressed: () => onImageClick.call(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}

class FileImageWidget extends StatelessWidget {
  final XFile file;
  final double height;
  final bool showViewMore;
  final int restImages;
  final Function() onPressed;
  final Function() onDelete;

  const FileImageWidget({
    Key? key,
    required this.file,
    required this.height,
    required this.onDelete,
    this.showViewMore = false,
    this.restImages = 0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(file.path),
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: onDelete,
                  child: SvgPicture.asset(
                    'assets/images/ic_remove.svg',
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ),
            if (showViewMore)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: Text(
                    "+$restImages",
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CachedPostImageWidget extends StatefulWidget {
  final PostImageModel? image;
  final double height;
  final Function() onPressed;
  final bool showViewMore;
  final int restImages;
  final MediaRawData? mediaRawData;
  final Function()? onDeleted;
  final bool showDelete;

  const CachedPostImageWidget({
    Key? key,
    this.height = 250,
    this.showViewMore = false,
    this.restImages = 0,
    required this.onPressed,
    this.image,
    this.mediaRawData,
    this.onDeleted,
    this.showDelete = false,
  }) : super(key: key);

  @override
  State<CachedPostImageWidget> createState() => _CachedPostImageWidgetState();
}

class _CachedPostImageWidgetState extends State<CachedPostImageWidget> {
  String coverUrl = '';
  String videoUrl = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getCoverUrl() async {
    if (coverUrl.isEmpty) {
      if (widget.image?.mediableType == 'post_video') {
        await AppApi.instance
            .getVideoUrl(videoId: widget.image?.filePath ?? '')
            .then(
          (videoLoadRes) {
            if (videoLoadRes != null) {
              setState(() {
                coverUrl = videoLoadRes.data?.videoMeta?.coverUrl ?? '';
                videoUrl = videoLoadRes.data?.videoUrl ?? '';
              });
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl =
        widget.image?.filePath ?? widget.mediaRawData?.filePath;
    final int? id = widget.image?.id ?? widget.mediaRawData?.postId;
    if (imageUrl.isNullOrEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: Text("Failed to load image!")),
      );
    }
    getCoverUrl();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        child: Hero(
          tag: "${widget.image?.heroPrefix}_${id}_post_image_$imageUrl",
          child: Stack(
            alignment: Alignment.center,
            children: [
              (widget.image?.mediableType == 'post_video')
                  ? (videoUrl.isEmpty)
                      ? const SizedBox.shrink()
                      : VideoItem(
                          videoUrl: videoUrl,
                          isAutoPlay: false,
                        )
                  // Stack(
                  //     children: [
                  //       Image.network(
                  //         coverUrl,
                  //         height: widget.height,
                  //         width: double.infinity,
                  //         fit: BoxFit.cover,
                  //         errorBuilder: (context, error, stackTrace) =>
                  //             Container(
                  //           color: Colors.grey.shade300,
                  //           child: const Center(
                  //               child: Text("Failed to load image!")),
                  //         ),
                  //       ),
                  //       // CachedNetworkImage(
                  //       //   imageUrl: coverUrl,
                  //       //   height: widget.height,
                  //       //   width: double.infinity,
                  //       //    fit: BoxFit.cover,
                  //       //   // fit: BoxFit.contain,
                  //       //   placeholder: (c, s) =>
                  //       //       Container(color: Colors.grey.shade300),
                  //       //   errorWidget: (c, a, b) => Container(
                  //       //     color: Colors.grey.shade300,
                  //       //     child: const Center(
                  //       //         child: Text("Failed to load image!")),
                  //       //   ),
                  //       // ),

                  //       Align(
                  //         child: Container(
                  //             padding: const EdgeInsets.all(8),
                  //             decoration: const BoxDecoration(
                  //                 color: Colors.white70,
                  //                 shape: BoxShape.circle),
                  //             child: const Icon(
                  //               Icons.play_arrow,
                  //               size: 35,
                  //               color: Colors.black45,
                  //             )),
                  //       )
                  //     ],
                  //   )
                  : Image.network(
                      kTempImageHost + imageUrl!,
                      height: widget.height,
                      width: double.infinity,
                      // TODO Change Cover
                      // fit: BoxFit.cover,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child:
                            const Center(child: Text("Failed to load image!")),
                      ),
                    ),
              // CachedNetworkImage(
              //   imageUrl: kTempImageHost + imageUrl!,
              //   height: widget.height,
              //   width: double.infinity,
              //   // TODO Change Cover
              //   // fit: BoxFit.cover,
              //   fit: BoxFit.contain,
              //   placeholder: (c, s) => Container(color: Colors.grey.shade300),
              //   errorWidget: (c, a, b) => Container(
              //     color: Colors.grey.shade300,
              //     child: const Center(child: Text("Failed to load image!")),
              //   ),
              // ),
              if (widget.showDelete)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: widget.onDeleted,
                      child: SvgPicture.asset(
                        'assets/images/ic_remove.svg',
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),
              if (widget.showViewMore)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Center(
                    child: Text(
                      "+${widget.restImages}",
                      textAlign: TextAlign.center,
                      style: kTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostFooterItemWidget extends StatelessWidget {
  final String svgPath;
  final String text;
  final bool isActive;
  final bool isReactItem;
  final Function() onPressed;
  final Function()? onLongPressed;

  const PostFooterItemWidget({
    Key? key,
    required this.svgPath,
    required this.text,
    required this.isActive,
    this.isReactItem = false,
    required this.onPressed,
    this.onLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              (isReactItem && isActive)
                  ? Image.asset(
                      svgPath,
                      width: 20,
                      height: 20,
                    )
                  : SvgPicture.asset(
                      svgPath,
                      width: 20,
                      height: 20,
                      // ignore: deprecated_member_use
                      color: isActive ? kThemePrimaryColor : null,
                    ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kTextStyle.copyWith(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
