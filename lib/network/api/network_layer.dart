import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:teatalk/model/post.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/model/video_req.dart';
import 'package:teatalk/util/ao_lib.dart';

import '../../util/constant.dart';
import '../../util/post_privacy.dart';

class NetworkLayerApi {
  static NetworkLayerApi? _instance;

  static NetworkLayerApi get instance => _instance ??= NetworkLayerApi();

  late Dio dio;

  NetworkLayerApi() {
    dio = Dio();
    dio.options.baseUrl = kApiHost;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.followRedirects = true;
    dio.options.maxRedirects = 3;
    dio.options.receiveDataWhenStatusError = true;
  }

  Future<http.Response> register({required UserModel userModel}) async {
    final Map<String, dynamic> tmpBody = userModel.toJson()
      ..remove("authToken")
      ..remove("user_id");
    return await http.post(
      Uri.parse("${kApiHost}auth/register"),
      body: tmpBody,
    );
  }

  Future<http.Response> login({required String ph, required String pw}) async {
    return await http.post(
      Uri.parse("${kApiHost}auth/login"),
      body: {"phone": ph, "password": pw},
    );
  }

  Future<http.Response> resetPassword({
    required String ph,
    required pw,
    required cPw,
    required otp,
  }) async {
    return await http.post(
      Uri.parse("${kApiHost}auth/reset-password"),
      body: {
        "phone": ph,
        "password": pw,
        "confirm_password": cPw,
        "otp": otp,
      },
    );
  }

  Future<http.Response> changePassword({
    required newPw,
    required confirmPw,
    required oldPw,
  }) async {
    return await http.post(
      Uri.parse("${kApiHost}auth/change-password"),
      body: {
        "old_password": oldPw,
        "new_password": newPw,
        "confirm_password": confirmPw,
      },
    );
  }

  Future<http.Response> requestOTP({required String ph}) async {
    return await http.post(
      Uri.parse("${kApiHost}otp/request"),
      body: {"phone": ph},
    );
  }

  Future<http.Response> requestForgetPasswordOTP({required String ph}) async {
    return await http.post(
      Uri.parse("${kApiHost}otp/forget-password"),
      body: {"phone": ph},
    );
  }

  Future<http.Response> validateOTP(
      {required String otp, required String clientRef}) async {
    return await http.post(
      Uri.parse("${kApiHost}otp/validation"),
      body: {"otp": otp, "client_ref": clientRef},
    );
  }

  Future<http.StreamedResponse> showUserProfile({
    required int userId,
    required String token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('GET', Uri.parse("${kApiHost}user/show/$userId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getLoggedInUser({
    required String token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('GET', Uri.parse("${kApiHost}user/info"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getBuddyList({required String token}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('GET', Uri.parse("${kApiHost}friend"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getBuddyReceived(
      {required String token}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}friend/received-list"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getBuddyRequested(
      {required String token}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}friend/requested-list"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> addFriend(
      {required String token, required int userId}) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('POST', Uri.parse("${kApiHost}friend/add"));
    req.bodyFields = {'user_id': userId.toString()};
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> unFriend(
      {required String token, required int userId}) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('POST', Uri.parse("${kApiHost}friend/unfriend"));
    req.bodyFields = {'friend_id': userId.toString()};
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> confirmBuddyRequest({
    required String token,
    required int requestedUserId,
    required int status,
  }) async {
    // 1 is accept, 2 is reject
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    final req =
        http.Request('POST', Uri.parse("${kApiHost}friend/accept-or-reject"));
    req.bodyFields = {
      'status': status.toString(),
      'requester_id': requestedUserId.toString(),
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> cancelYourRequest({
    required String token,
    required int recipientId,
  }) async {
    // 1 is accept, 2 is reject
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request(
        'POST', Uri.parse("${kApiHost}friend/cancel-by-requester"));
    req.bodyFields = {'recipient_id': recipientId.toString()};
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> findFriends({
    required String token,
    required String search,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}friend/find?search=$search"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getFreshFlash({
    required String token,
    required int start,
    int size = 15,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('GET',
        Uri.parse("${kApiHost}post/fresh-flash?start=$start&size=$size"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getDiaryPosts({
    required int userId,
    required String token,
    required int start,
    int size = 15,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('GET',
        Uri.parse("${kApiHost}post/my-diary/$userId?start=$start&size=$size"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getDiaryMedia({
    required int userId,
    required String token,
    required int start,
    int size = 15,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request(
        'GET',
        Uri.parse(
            "${kApiHost}my-diary/medias/$userId?start=$start&size=$size"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getActivities({required String token}) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request('GET', Uri.parse("${kApiHost}activities"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getLocations({int? parentId}) async {
    String url = "${kApiHost}locations";
    if (parentId != null) url = "${kApiHost}locations/$parentId";
    final req = http.Request('GET', Uri.parse(url));
    return await req.send();
  }

  Future<http.StreamedResponse> getMyArena({
    required String token,
    required int start,
    int size = 15,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request(
        'GET', Uri.parse("${kApiHost}post/my-arena?start=$start&size=$size"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getSearch(
      {required String token, required String searchValue}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}search?search=$searchValue"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> createPost({
    required String token,
    required String content,
    required PostPrivacy privacy,
    required List<XFile> media,
    String mediaType = "post_image",
    String feeling = "DEFAULT",
    VideoReq? videoReq,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req =
        http.MultipartRequest('POST', Uri.parse("${kApiHost}post/create"));
    req.headers.addAll(headers);

    req.fields.addAll({
      'content': AoLib.instance.emojiToHtml(content),
      'media_type': mediaType,
      'privacy': privacy.code,
      'feeling': feeling,
    });
    if (videoReq != null && media.isEmpty) {
      var data = {
        "mediableType": "post_video",
        "fileName": videoReq.fileName,
        "fileSize": videoReq.fileSize,
        "fileType": videoReq.fileType,
        "videoId": videoReq.videoId
      };
      req.fields.addAll({'video': jsonEncode(data)});
    }

    if (media.isNotEmpty) {
      for (final postMedium in media) {
        final bytes = await postMedium.readAsBytes();
        final String extension = path.extension(postMedium.name);
        final httpImage = http.MultipartFile.fromBytes(
          'post_medias',
          bytes,
          filename: postMedium.name,
          contentType: MediaType('image', extension.replaceAll('.', '')),
        );
        req.files.add(httpImage);
      }
    }

    return await req.send();
  }

  Future<http.StreamedResponse> sharePost({
    required String token,
    required int postId,
    String feeling = "DEFAULT",
    required PostPrivacy privacy,
    required String content,
  }) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    final req = http.Request('POST', Uri.parse("${kApiHost}post/share"));
    req.bodyFields = {
      'postId': postId.toString(),
      'feeling': feeling,
      'privacy': privacy.code,
      'content': AoLib.instance.emojiToHtml(content)
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> editPost(
      {required String token,
      required PostModel post,
      String feeling = "DEFAULT",
      required List<XFile> media,
      String mediaType = "post_image",
      VideoReq? videoReq}) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.MultipartRequest(
        'PUT', Uri.parse("${kApiHost}post/edit/${post.id}"));
    req.headers.addAll(headers);

    req.fields.addAll({
      'content': AoLib.instance.emojiToHtml(post.content),
      'privacy': post.privacy!,
      'feeling': feeling,
      'media_type': mediaType,
    });

    if (videoReq != null && media.isEmpty) {
      var data = {
        "mediableType": "post_video",
        "fileName": videoReq.fileName,
        "fileSize": videoReq.fileSize,
        "fileType": videoReq.fileType,
        "videoId": videoReq.videoId
      };
      req.fields.addAll({'video': jsonEncode(data)});
    }

    if (media.isNotEmpty) {
      for (final postMedium in media) {
        final bytes = await postMedium.readAsBytes();
        final String extension = path.extension(postMedium.name);
        final httpImage = http.MultipartFile.fromBytes(
          'post_medias',
          bytes,
          filename: postMedium.name,
          contentType: MediaType('image', extension.replaceAll('.', '')),
        );
        req.files.add(httpImage);
      }
    }

    return await req.send();
  }

  Future<http.StreamedResponse> updateDiary({
    required UserProfileModel userProfile,
    required String token,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req =
        http.Request('PUT', Uri.parse("${kApiHost}user/${userProfile.userId}"));
    req.headers.addAll(headers);
    req.bodyFields = {
      'firstName': userProfile.firstName!,
      'lastName': userProfile.lastName!,
      'nickName': userProfile.nickName!,
      'email': userProfile.email!,
      'maritalStatus': userProfile.maritalStatus!,
      'gender': userProfile.gender!,
      'bio': userProfile.bio!,
      'birth_date': userProfile.birthDate!,
    };

    return await req.send();
  }

  Future<http.StreamedResponse> getReactions({required String token}) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request('GET', Uri.parse("${kApiHost}react/react-icons"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getComments({
    required String token,
    required int postId,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request(
        'GET', Uri.parse("${kApiHost}comment/list-per-post/$postId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getReplyComments({
    required String token,
    required int postId,
    required int commentId,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request('GET',
        Uri.parse("${kApiHost}comment/list-per-comment/$postId/$commentId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> deletePostMedia({
    required String token,
    required int mediaId,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request(
        'DELETE', Uri.parse("${kApiHost}post/media/single-delete/$mediaId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> deletePost({
    required String token,
    required int postId,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req =
        http.Request('DELETE', Uri.parse("${kApiHost}post/delete/$postId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> notifications({required String token}) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.Request('GET', Uri.parse("${kApiHost}notifications"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getPostDetail({
    required String token,
    required int postId,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}post/detail/$postId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> addComment({
    required String token,
    required int postId,
    required String comment,
  }) async {
    final headers = {'Authorization': 'Bearer $token'};
    final req = http.MultipartRequest(
        'POST', Uri.parse("${kApiHost}comment/add-to-post"));
    req.headers.addAll(headers);
    req.fields.addAll({
      'post_id': postId.toString(),
      'comment': AoLib.instance.emojiToHtml(comment),
    });
    return await req.send();
  }

  Future<http.StreamedResponse> reactToComment({
    required String token,
    required int commentId,
    required String reactKey,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req = http.Request('POST', Uri.parse("${kApiHost}react/to-comment"));
    req.bodyFields = {
      'comment_id': commentId.toString(),
      'react': reactKey,
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> replyToComment({
    required String token,
    required int postId,
    required int parentCommentId,
    required String comment,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('POST', Uri.parse("${kApiHost}comment/reply-to-comment"));
    req.bodyFields = {
      'comment': AoLib.instance.emojiToHtml(comment),
      'comment_id': parentCommentId.toString(),
      'post_id': postId.toString(),
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> reactToPost({
    required String token,
    required int postId,
    required String reactKey,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req = http.Request('POST', Uri.parse("${kApiHost}react/to-post"));
    req.bodyFields = {
      'post_id': postId.toString(),
      'react': reactKey,
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> reactsOfPost({
    required String token,
    required int postId,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}react/react-users/$postId"));
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> profileImageUpload(
      {required String token,
      required XFile image,
      required bool isProfile}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    String mediaType = isProfile ? 'user_profile_image' : 'user_cover_image';
    final req = http.MultipartRequest(
        'POST', Uri.parse("${kApiHost}media/single-file-upload"));

    req.headers.addAll(headers);
    req.fields.addAll({'media_type': mediaType});

    // Add Image
    final bytes = await image.readAsBytes();
    final String extension = path.extension(image.name);
    final httpImage = http.MultipartFile.fromBytes('user_profile', bytes,
        filename: image.name,
        contentType: MediaType('image', extension.replaceAll('.', '')));
    req.files.add(httpImage);

    return await req.send();
  }

  Future<http.StreamedResponse> postVideUpload(
      {required String token,
      required XFile videoFile,
      required String title}) async {
    final headers = {
      'Authorization': 'Bearer $token',
    };
    final req =
        http.MultipartRequest('POST', Uri.parse("${kApiVideoHost}upload"));

    req.headers.addAll(headers);
    req.fields.addAll({'title': title});

    // Add Image
    // final bytes = await videoFile.readAsBytes();
    // final String extension = path.extension(videoFile.name);
    final httpVideo = await http.MultipartFile.fromPath('file', videoFile.path);
    req.files.add(httpVideo);
    print('VIDEO ADD DONE');
    return await req.send();
  }

  Future<http.StreamedResponse> postViewNotification(
      {required String token, required int notiId}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('POST', Uri.parse("${kApiHost}notifications/view"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> postReadNotification(
      {required String token, required int notiId}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('POST', Uri.parse("${kApiHost}notifications/read"));
    req.bodyFields = {
      'notificationId': notiId.toString(),
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> putEditComment(
      {required String token,
      required int commentId,
      required String comment}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('PUT', Uri.parse("${kApiHost}comment/edit/$commentId"));
    req.bodyFields = {
      'comment': comment,
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> deleteComment({
    required String token,
    required int commentId,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req = http.Request(
        'DELETE', Uri.parse("${kApiHost}comment/delete/$commentId"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getIceCount({
    required String token,
  }) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('GET', Uri.parse("${kApiHost}ims/accounts/ice-balance"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getStickerPerPost(
      {required String token, required int postId}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req = http.Request(
        'POST', Uri.parse("${kApiHost}ims/stickers/list-per-post"));
    req.bodyFields = {
      'postId': postId.toString(),
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getStickerList({required int age}) async {
    final headers = {
      'Authorization': 'Bearer $kApiStickerToken',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('GET', Uri.parse("${kApiStickerHost}categories?age=$age"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> postSticker(
      {required String token,
      required int stickerId,
      required String stickerUrl,
      required int postId,
      required double stickerAmount}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req = http.Request('POST', Uri.parse("${kApiHost}ims/stickers/sent"));
    req.bodyFields = {
      'stickerId': stickerId.toString(),
      'stickerUrl': stickerUrl,
      'postId': postId.toString(),
      'stickerAmount': stickerAmount.toString(),
    };
    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getVideoLoad({required String videoId}) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('GET', Uri.parse("${kApiVideoHost}load?videoId=$videoId"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getVideoUrl({required String videoId}) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req = http.Request(
        'GET', Uri.parse("${kApiVideoHost}mobile/get-url?videoId=$videoId"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> getStickerTransactionHistory(
      {required String token}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final req = http.Request('GET',
        Uri.parse("${kApiHost}ims/transactions/sticker-transaction-history"));

    req.headers.addAll(headers);
    return await req.send();
  }

  Future<http.StreamedResponse> postChangePassword(
      {required String token,
      required String oldPassword,
      required String newPassword}) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final req =
        http.Request('POST', Uri.parse("${kApiHost}auth/change-password"));

    req.bodyFields = {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': newPassword,
    };

    req.headers.addAll(headers);
    return await req.send();
  }
}
