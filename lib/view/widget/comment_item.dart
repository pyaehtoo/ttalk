import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/comments_res.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/log.dart';
import 'package:teatalk/view/screen/app/diary/diary.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class CommentItemWidget extends StatefulWidget {
  final CommentsData commentsData;
  final int postId;
  final bool isReplyComment;
  final bool isRelyFocused;
  final Function(int, bool) onLikeCallback;
  final Function(int, String) onReplyCallback;
  final Function(int)? onViewAllCallback;
  final Function(int, String) onEditCallback;
  final Function(int) onDeletedCallback;
  final bool isMyOwnPost;

  const CommentItemWidget(
      {Key? key,
      required this.commentsData,
      required this.postId,
      this.isReplyComment = false,
      this.isRelyFocused = false,
      required this.onLikeCallback,
      required this.onReplyCallback,
      required this.onEditCallback,
      required this.onDeletedCallback,
      this.isMyOwnPost = false,
      this.onViewAllCallback})
      : super(key: key);

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  bool isViewAllComment = false;
  List<CommentsData> replyComments = [];
  bool isReacted = false;
  int reactCount = 0;

  @override
  void initState() {
    super.initState();
    isViewAllComment = widget.commentsData.isViewAllComment ?? false;
    print('isViewAll =====> $isViewAllComment');
    isReacted = widget.commentsData.reactByMe != 0;
    reactCount = widget.commentsData.reactCount ?? 0;
    if (isViewAllComment) {
      _viewAllComment();
      // _getReplyComments();
    }
  }

  void _reactComment(int id, bool isTap) {
    widget.onLikeCallback.call(id, isTap);
    setState(() {
      if (isReacted) {
        reactCount--;
      } else {
        reactCount++;
      }
      print('React COunt =====> $reactCount');
      isReacted = !isReacted;
    });
  }

  _viewAllComment() async {
    // if (isViewAllComment) {
    //   setState(() {
    //     replyComments.clear();
    //     isViewAllComment = false;
    //     widget.onViewAllCallback?.call(widget.commentsData.id);
    //   });
    // } else {
    setState(() {
      _getReplyComments();
      isViewAllComment = true;
      widget.onViewAllCallback?.call(widget.commentsData.id);
    });
    // }
  }

  _getReplyComments() async {
    //  if (!isViewAllComment) {
    AppApi.instance
        .getReplyComments(
            context: context,
            commentId: widget.commentsData.id,
            postId: widget.postId)
        .then((commentsRes) {
      if (commentsRes != null) {
        replyComments.clear();
        setState(() {
          replyComments.addAll(commentsRes.data ?? []);
          // isViewAllComment = true;
        });
      }
    });
    // widget.onViewAllCallback?.call(widget.commentsData.id);
    // } else {
    //   setState(() {
    //     replyComments.clear();
    //     isViewAllComment = false;
    //     widget.onViewAllCallback?.call(widget.commentsData.id);
    //   });
    // }
  }

  void goToBuddy(int id) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DiaryScreen(userId: id)));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(widget.commentsData.createdAt);
    // final int reactCount = widget.commentsData.reactCount;
    final int replyCount = widget.commentsData.replyCount;
    final bool isMyComment = widget.commentsData.commenter.id == context.userId;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                goToBuddy(widget.commentsData.commenter.id);
              },
              child: AvatarWidget(
                profileUrl:
                    widget.commentsData.commenter.profile?.profileImageUrl,
                size: 35,
              ),
            ),
            kSpacerH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      // color: kThemeColor.withOpacity(0.4),
                      color: kCommentBgColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        kSpacerV,
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    goToBuddy(widget.commentsData.commenter.id);
                                  },
                                text:
                                    "${widget.commentsData.commenter.nickName}  ",
                                style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              WidgetSpan(
                                child: Timeago(
                                  builder: (c, s) {
                                    return Text(
                                      (s == 'now')
                                          ? "just now"
                                          : "${s.replaceAll("~", "")} ago",
                                      style: kTextStyle.copyWith(
                                        fontSize: 13,
                                        color: kThemeSecTextColor,
                                      ),
                                    );
                                  },
                                  locale: 'en_short',
                                  date: createdAt,
                                ),
                              ),
                            ],
                          ),
                        ),
                        kSpacerV,

                        Linkify(
                          text: AoLib.instance.htmlCharCodeToEmoji(
                              widget.commentsData.comment?.trim()),
                          onOpen: (link) async {
                            await AoLib.instance.openUrl(link.url);
                          },
                          maxLines: 100,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xff2F2E41),
                              fontFamily: 'Graphie',
                              fontSize: 15,
                              height: 1.7),
                        ),
                        // PostItemContentTextWidget(
                        //   content: widget.commentsData.comment ?? '',
                        //   isPaddingFalse: true,
                        //   isReply: true,
                        //   bgColor: kCommentBgColor,
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          _reactComment(widget.commentsData.id, true);
                          // widget.onLikeCallback(widget.commentsData.id, true);
                          Log.d("Like");
                        },
                        // onLongPress: () {
                        //   widget.onLikeCallback(widget.commentsData.id, false);
                        //   Log.d("Press");
                        // },
                        child: Text(
                          '${(reactCount <= 0) ? '' : reactCount.toString()} Like',
                          style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            decorationColor: isReacted
                                ? kThemeColor.withAlpha(170)
                                : kThemeSecTextColor.withAlpha(170),
                            color: isReacted ? kThemeColor : kThemeSecTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onReplyCallback(widget.commentsData.id,
                              widget.commentsData.commenter.nickName ?? '');
                          //  if (widget.isRelyFocused) _viewAllComment();
                          Log.d("Reply");
                        },
                        child: Text(
                          'Reply',
                          style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            decorationColor: kThemeSecTextColor.withAlpha(170),
                            color: kThemeSecTextColor,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isMyComment,
                        child: const SizedBox(
                          width: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onEditCallback(widget.commentsData.id,
                              widget.commentsData.comment ?? '');
                        },
                        child: Visibility(
                          visible: isMyComment,
                          child: Text(
                            'Edit',
                            style: kTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              decorationColor:
                                  kThemeSecTextColor.withAlpha(170),
                              color: kThemeSecTextColor,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isMyComment || widget.isMyOwnPost,
                        child: const SizedBox(
                          width: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onDeletedCallback(widget.commentsData.id);
                        },
                        child: Visibility(
                          visible: isMyComment || widget.isMyOwnPost,
                          child: Text(
                            'Delete',
                            style: kTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              decorationColor:
                                  kThemeSecTextColor.withAlpha(170),
                              color: kThemeSecTextColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                    ],
                  ),
                  // Visibility(
                  //   visible: !widget.isReplyComment,
                  //   child: RichText(
                  //     text: TextSpan(
                  //       children: [
                  //         linkButtonWidget(
                  //           "${(reactCount <= 0) ? '' : reactCount.toString()} Like",
                  //           color: widget.commentsData.reactByMe == 0
                  //               ? kThemeSecTextColor
                  //               : kThemeColor,
                  //           underline: false,
                  //           () {
                  //             widget.onLikeCallback(widget.commentsData.id);
                  //             Log.d("Like");
                  //           },
                  //         ),
                  //         TextSpan(
                  //           text: "    ",
                  //           style: kTextStyle.copyWith(
                  //               color: kThemeSecTextColor.withOpacity(0.5)),
                  //         ),
                  //         linkButtonWidget(
                  //           "${(replyCount <= 0) ? '' : replyCount.toString()} Reply",
                  //           color: kThemeSecTextColor,
                  //           underline: false,
                  //           () {
                  //             widget.onReplyCallback(widget.commentsData.id,
                  //                 widget.commentsData.commenter.nickName ?? '');
                  //             // if (widget.isRelyFocused) _viewAllComment();
                  //             Log.d("Reply");
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Visibility(
                      visible: widget.commentsData.replyCount > 0,
                      child: kSpacerV),
                  Visibility(
                    visible: widget.commentsData.replyCount > 0,
                    child: GestureDetector(
                        onTap: () {
                          _viewAllComment();
                        },
                        child: Text(isViewAllComment ? '' : 'View all buzzes')),
                  ),
                  // Visibility(visible: isViewAllComment, child: kSpacerV),
                  // Visibility(
                  //     visible: isViewAllComment,
                  //     child: ListView.builder(
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       itemCount: replyComments.length,
                  //       itemBuilder: (context, index) {
                  //         return CommentItemWidget(
                  //           commentsData: replyComments[index],
                  //           postId: widget.postId,
                  //           onLikeCallback: (_, __) {},
                  //           onReplyCallback: (_, name) {},
                  //           isReplyComment: true,
                  //           onDeletedCallback: (_) {},
                  //           onEditCallback: (_, __) {},
                  //         );
                  //       },
                  //     )),
                  // Visibility(visible: !widget.isReplyComment, child: kSpacerV),
                  // Visibility(visible: !widget.isReplyComment, child: kSpacerV),
                ],
              ),
            ),
          ],
        ),
        Visibility(
            visible: isViewAllComment,
            child: ListView.builder(
              padding: EdgeInsets.only(left: (widget.isReplyComment) ? 5 : 45),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: replyComments.length,
              itemBuilder: (context, index) {
                return CommentItemWidget(
                  commentsData: replyComments[index],
                  postId: widget.postId,
                  onLikeCallback: (commentId, isTap) {
                    widget.onLikeCallback(commentId, isTap);
                  },
                  onReplyCallback: (commentId, userName) {
                    widget.onReplyCallback(commentId, userName);
                  },
                  isReplyComment: true,
                  onDeletedCallback: (commentId) {
                    widget.onDeletedCallback(commentId);
                  },
                  onEditCallback: (commentId, comment) {
                    widget.onEditCallback(commentId, comment);
                  },
                  isMyOwnPost: widget.isMyOwnPost,
                  // onLikeCallback: (commentId, isTap) {
                  //   _reactComment(commentId, isTap);
                  // },
                  // onReplyCallback: (commentId, userName) {
                  //   _replyCommentState(commentId, userName);
                  // },
                  // onViewAllCallback: (commentId) {
                  //   _viewAllComment(commentId);
                  // },
                  // onDeletedCallback: (commentId) {
                  //   _deleteComment(commentId);
                  // },
                  // onEditCallback: (commentId, comment) {
                  //   _editCommentState(commentId, comment);
                  // },
                  // isMyOwnPost: _post?.postBy == context.userId,
                );
              },
            )),
        // Visibility(visible: !widget.isReplyComment, child: kSpacerV),
        Visibility(visible: !widget.isReplyComment, child: kSpacerV),
      ],
    );
  }
}
