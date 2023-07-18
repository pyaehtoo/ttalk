import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/model/video_req.dart';
import 'package:teatalk/network/api/network_layer.dart';
import 'package:teatalk/network/res/activities_res.dart';
import 'package:teatalk/network/res/buddy_list_res.dart';
import 'package:teatalk/network/res/buddy_rec_list_res.dart';
import 'package:teatalk/network/res/find_buddy_res.dart';
import 'package:teatalk/network/res/ice_count_res.dart';
import 'package:teatalk/network/res/location_res.dart';
import 'package:teatalk/network/res/login_res.dart';
import 'package:teatalk/network/res/media_res.dart';
import 'package:teatalk/network/res/notification_res.dart';
import 'package:teatalk/network/res/otp_request_res.dart';
import 'package:teatalk/network/res/otp_validation_res.dart';
import 'package:teatalk/network/res/post_detail_res.dart';
import 'package:teatalk/network/res/reaction_res.dart';
import 'package:teatalk/network/res/register_res.dart';
import 'package:teatalk/network/res/reset_pw_res.dart';
import 'package:teatalk/network/res/search_res.dart';
import 'package:teatalk/network/res/sticker_per_post_res.dart';
import 'package:teatalk/network/res/sticker_res.dart';
import 'package:teatalk/network/res/transaction_res.dart';
import 'package:teatalk/network/res/user_profile_res.dart';
import 'package:teatalk/network/res/video_load_res.dart';
import 'package:teatalk/network/res/video_upload_res.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/service/db_keys.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/log.dart';

import '../../model/post.dart';
import '../res/buddy_req_list_res.dart';
import '../res/comments_res.dart';
import '../res/create_post_res.dart';
import '../res/default_res.dart';
import '../res/post_reacts_res.dart';
import '../res/post_res.dart';

class AppApi {
  static AppApi? _instance;

  static AppApi get instance => _instance ??= AppApi();

  AppApi();

  Future<OtpRequestRes?> requestOtp({required String phone}) async {
    try {
      final Response res = await NetworkLayerApi.instance.requestOTP(ph: phone);
      Log.d(res.body);
      return OtpRequestRes.fromJson(jsonDecode(res.body));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<OtpRequestRes?> requestForgetPasswordOtp(
      {required String phone}) async {
    try {
      final Response res =
          await NetworkLayerApi.instance.requestForgetPasswordOTP(ph: phone);
      Log.d(res.body);
      return OtpRequestRes.fromJson(jsonDecode(res.body));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<OtpValidationRes?> validateOtp(
      {required String clientRef, required String otp}) async {
    try {
      final Response res = await NetworkLayerApi.instance
          .validateOTP(clientRef: clientRef, otp: otp);
      return OtpValidationRes.fromJson(jsonDecode(res.body));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<RegisterRes?> register({required UserModel userModel}) async {
    try {
      final Response res =
          await NetworkLayerApi.instance.register(userModel: userModel);
      return RegisterRes.fromJson(jsonDecode(res.body));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<ResetPwRes?> resetPassword({
    required String phone,
    required String otp,
    required String password,
  }) async {
    try {
      final Response res = await NetworkLayerApi.instance
          .resetPassword(ph: phone, otp: otp, pw: password, cPw: password);
      return ResetPwRes.fromJson(jsonDecode(res.body));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<LoginRes?> login(
      {required String phone, required String password}) async {
    try {
      final Response res =
          await NetworkLayerApi.instance.login(ph: phone, pw: password);
      return LoginRes.fromJson(jsonDecode(res.body));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<BuddyListRes?> buddyList({required BuildContext context}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getBuddyList(token: token);
      final String resStr = await res.stream.bytesToString();
      return BuddyListRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d("buddyList $e");
    }
    return null;
  }

  Future<BuddyRecListRes?> getBuddyReceivedList(
      {required BuildContext context}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getBuddyReceived(token: token);
      final String resStr = await res.stream.bytesToString();
      return BuddyRecListRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d("getBuddyReceivedList $e");
    }
    return null;
  }

  Future<BuddyReqListRes?> getBuddyRequestedList(
      {required BuildContext context}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getBuddyRequested(token: token);
      final String resStr = await res.stream.bytesToString();
      return BuddyReqListRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d("getBuddyRequestedList $e");
    }
    return null;
  }

  Future<FindBuddyRes?> findBuddy(
      {required BuildContext context, String? search}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .findFriends(token: token, search: search ?? '');
      final String resStr = await res.stream.bytesToString();
      return FindBuddyRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<FindBuddyRes?> addBuddy(
      {required BuildContext context, required int userId}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .addFriend(token: token, userId: userId);
      final String resStr = await res.stream.bytesToString();
      return FindBuddyRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<FindBuddyRes?> unBuddy(
      {required BuildContext context, required int userId}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.unFriend(token: token, userId: userId);
      final String resStr = await res.stream.bytesToString();
      Log.d(resStr);
      return FindBuddyRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<FindBuddyRes?> cancelRequestedBuddy(
      {required BuildContext context, required int userId}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .cancelYourRequest(token: token, recipientId: userId);
      final String resStr = await res.stream.bytesToString();
      return FindBuddyRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<FindBuddyRes?> confirmReceivedBuddy({
    required BuildContext context,
    required int requestedUserId,
    required int status,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.confirmBuddyRequest(
        token: token,
        requestedUserId: requestedUserId,
        status: status,
      );
      final String resStr = await res.stream.bytesToString();
      return FindBuddyRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<UserProfileRes?> userProfile(
      {required BuildContext context, required int userId}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .showUserProfile(token: token, userId: userId);
      final String resStr = await res.stream.bytesToString();
      return UserProfileRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<UserProfileRes?> getLoggedInUser({required String token}) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getLoggedInUser(
        token: token,
      );
      final String resStr = await res.stream.bytesToString();
      UserProfileRes? userProfileRes =
          UserProfileRes.fromJson(jsonDecode(resStr));
      if (userProfileRes.data != null) {
        DbService.instance.saveLoggedInUser(userProfileRes.data!);
      }
      return userProfileRes;
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<PostRes?> getMyArena({
    required String? userToken,
    required int start,
  }) async {
    final token = userToken;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getMyArena(token: token, start: start);
      final String resStr = await res.stream.bytesToString();
      return PostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<PostRes?> getFreshFlash({
    required String? userToken,
    required int start,
  }) async {
    final token = userToken;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getFreshFlash(token: token, start: start);
      final String resStr = await res.stream.bytesToString();
      return PostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<SearchRes?> getSearch({
    required String token,
    required String searchValue,
  }) async {
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getSearch(token: token, searchValue: searchValue);
      final String resStr = await res.stream.bytesToString();
      return SearchRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<PostRes?> getDiaryPosts({
    required BuildContext context,
    required int userId,
    required int start,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getDiaryPosts(token: token, start: start, userId: userId);
      final String resStr = await res.stream.bytesToString();
      return PostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<MediaRes?> getDiaryMedia({
    required BuildContext context,
    required int userId,
    required int start,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getDiaryMedia(token: token, start: start, userId: userId);
      final String resStr = await res.stream.bytesToString();
      return MediaRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<ActivitiesRes?> getActivities({required BuildContext context}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getActivities(token: token);
      final String resStr = await res.stream.bytesToString();
      return ActivitiesRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<LocationRes?> getLocations({int? parentId}) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getLocations(parentId: parentId);
      final String resStr = await res.stream.bytesToString();
      return LocationRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<CreatePostRes?> createPost({
    required BuildContext context,
    required String content,
    required List<XFile> media,
    VideoReq? video,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.createPost(
        token: token,
        content: content,
        privacy: context.selectedPrivacy,
        media: media,
        videoReq: video,
      );
      final String resStr = await res.stream.bytesToString();
      return CreatePostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> sharePost({
    required BuildContext context,
    required int postId,
    required String content,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.sharePost(
          token: token,
          postId: postId,
          privacy: context.selectedPrivacy,
          content: content);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<CreatePostRes?> editPost({
    required BuildContext context,
    required PostModel post,
    String feeling = "DEFAULT",
    required List<XFile> media,
    String mediaType = "post_image",
    VideoReq? video,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.editPost(
          token: token,
          post: post,
          feeling: feeling,
          media: media,
          mediaType: mediaType,
          videoReq: video);
      final String resStr = await res.stream.bytesToString();
      return CreatePostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<CreatePostRes?> deletePostMedia({
    required BuildContext context,
    required PostImageModel postImage,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .deletePostMedia(token: token, mediaId: postImage.id);
      final String resStr = await res.stream.bytesToString();
      return CreatePostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<CreatePostRes?> deletePost({
    required BuildContext context,
    required int postId,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .deletePost(token: token, postId: postId);
      final String resStr = await res.stream.bytesToString();
      Log.d(resStr);
      return CreatePostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<UserProfileRes?> updateDiary({
    required BuildContext context,
    required UserProfileModel userProfile,
  }) async {
    final token = context.token;
    if (token == null) return null;
    userProfile.userId = context.userId;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .updateDiary(userProfile: userProfile, token: token);
      final String resStr = await res.stream.bytesToString();
      return UserProfileRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<ReactionRes?> getReactions({
    required BuildContext context,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getReactions(token: token);
      final String resStr = await res.stream.bytesToString();
      return ReactionRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<CommentsRes?> getComments({
    required BuildContext context,
    required int postId,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.getComments(
        token: token,
        postId: postId,
      );
      final String resStr = await res.stream.bytesToString();
      return CommentsRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<CommentsRes?> getReplyComments(
      {required BuildContext context,
      required int postId,
      required int commentId}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getReplyComments(token: token, postId: postId, commentId: commentId);
      final String resStr = await res.stream.bytesToString();
      return CommentsRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<NotificationRes?> getNotifications(
      {required BuildContext context}) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.notifications(token: token);
      final String resStr = await res.stream.bytesToString();

      return NotificationRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<PostDetailRes?> getPostDetail({
    required BuildContext context,
    required int postId,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getPostDetail(token: token, postId: postId);
      final String resStr = await res.stream.bytesToString();
      return PostDetailRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> addComment({
    required BuildContext context,
    required int postId,
    required String comment,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .addComment(token: token, postId: postId, comment: comment);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<CommentsRes?> reactToComment({
    required String token,
    required int commentId,
    ReactionData? react,
  }) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.reactToComment(
        token: token,
        commentId: commentId,
        //TODO IF add another reaction, change this
        reactKey: react?.key ?? "LIKE",
      );
      final String resStr = await res.stream.bytesToString();
      return CommentsRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> replyToComment({
    required BuildContext context,
    required int parentCommentId,
    required int postId,
    required String comment,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .replyToComment(
              token: token,
              comment: comment,
              parentCommentId: parentCommentId,
              postId: postId);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> reactToPost({
    required BuildContext context,
    required int postId,
    required ReactionData react,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.reactToPost(
        token: token,
        postId: postId,
        reactKey: react.key,
      );
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<PostReactsRes?> reactsOfPost({
    required BuildContext context,
    required int postId,
  }) async {
    final token = context.token;
    if (token == null) return null;
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.reactsOfPost(
        token: token,
        postId: postId,
      );
      final String resStr = await res.stream.bytesToString();
      return PostReactsRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> uploadProfileImageOrCover(
      {required String token, required XFile image, required isProfile}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .profileImageUpload(token: token, image: image, isProfile: isProfile);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> readNotification(
      {required String token, required int notiId}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .postReadNotification(token: token, notiId: notiId);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }
    return null;
  }

  Future<DefaultRes?> viewNotification(
      {required String token, required List<int> notiIdList}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .postViewNotification(token: token, notiId: 0);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<DefaultRes?> editComment(
      {required String token,
      required int commentId,
      required String comment}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .putEditComment(token: token, commentId: commentId, comment: comment);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<DefaultRes?> deleteComment(
      {required String token, required int commentId}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .deleteComment(token: token, commentId: commentId);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<IceCubeCountRes?> getIceCubeCount({required String token}) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getIceCount(token: token);
      final String resStr = await res.stream.bytesToString();
      IceCubeCountRes? iceCubeCountRes =
          IceCubeCountRes.fromJson(jsonDecode(resStr));
      DbService.instance
          .saveDouble(KeyIceCubeCount, iceCubeCountRes.getIceCount());
      return iceCubeCountRes;
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<StickerPerPostRes?> getStickerPerPost(
      {required String token, required int postId}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getStickerPerPost(token: token, postId: postId);
      final String resStr = await res.stream.bytesToString();

      return StickerPerPostRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<StickerRes?> getStickerList({required int age}) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getStickerList(age: age);
      final String resStr = await res.stream.bytesToString();

      return StickerRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<DefaultRes?> postSticker(
      {required String token,
      required int stickerId,
      required String stickerUrl,
      required int postId,
      required double stickerAmount}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance.postSticker(
          token: token,
          stickerId: stickerId,
          stickerUrl: stickerUrl,
          postId: postId,
          stickerAmount: stickerAmount);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<VideoLoadRes?> getVideoLoad({required String videoId}) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getVideoLoad(videoId: videoId);
      final String resStr = await res.stream.bytesToString();
      return VideoLoadRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<VideoLoadRes?> getVideoUrl({required String videoId}) async {
    try {
      final StreamedResponse res =
          await NetworkLayerApi.instance.getVideoUrl(videoId: videoId);
      final String resStr = await res.stream.bytesToString();
      return VideoLoadRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<TransactionRes?> getStickerTransactionHistory(
      {required String token}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .getStickerTransactionHistory(token: token);
      final String resStr = await res.stream.bytesToString();
      TransactionRes? temp = TransactionRes.fromJson(jsonDecode(resStr));
      print('LENGTH OF TRANSACTION =================> ${temp.data?.length}');

      return TransactionRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<DefaultRes?> changeSticker(
      {required String token,
      required String oldPassword,
      required String newPassword}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .postChangePassword(
              token: token, oldPassword: oldPassword, newPassword: newPassword);
      final String resStr = await res.stream.bytesToString();
      return DefaultRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
    }

    return null;
  }

  Future<VideoUploadRes?> uploadVideo(
      {required String token, required title, required XFile video}) async {
    try {
      final StreamedResponse res = await NetworkLayerApi.instance
          .postVideUpload(token: token, videoFile: video, title: title);
      final String resStr = await res.stream.bytesToString();
      print('App RES =================> $resStr');
      VideoUploadRes videoUploadRes =
          VideoUploadRes.fromJson(jsonDecode(resStr));
      print(videoUploadRes.toString());
      return VideoUploadRes.fromJson(jsonDecode(resStr));
    } catch (e) {
      Log.d(e);
      return null;
    }
  }
}
