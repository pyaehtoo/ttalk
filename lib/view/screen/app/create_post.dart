import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/post.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/model/video_req.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/create_post_res.dart';
import 'package:teatalk/network/res/video_upload_res.dart';
import 'package:teatalk/provider/feed.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/log.dart';
import 'package:teatalk/util/post_privacy.dart';
import 'package:teatalk/view/screen/app/app.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:teatalk/view/widget/choose_privacy_bottom_sheet.dart';
import 'package:teatalk/view/widget/create_post_gallery.dart';
import 'package:teatalk/view/widget/post_item.dart';
import 'package:teatalk/view/widget/post_privacy_status.dart';
import 'package:teatalk/view/widget/video_item.dart';

import '../../theme/color.dart';
import '../../theme/text.dart';
import '../../widget/gallery_view_wrapper.dart';

class CreatePostScreen extends StatefulWidget {
  final PostModel? postModel;
  final Function(PostModel?)? onEditedCallback;

  const CreatePostScreen({
    Key? key,
    this.postModel,
    this.onEditedCallback,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentNode = FocusNode();
  bool _enablePost = false;
  final List<XFile> _postImages = [];
  XFile? _postVideo;
  final List<PostImageModel> _postImageModels = [];
  PostModel? _postModel;
  late FeedProvider _feedProvider;
  late UserProvider _userProvider;
  List<PostImageModel> deletedPhotosIdList = [];

  @override
  void initState() {
    super.initState();
    _feedProvider = context.read();
    _userProvider = context.read();
    _postModel = widget.postModel;
    _init();
  }

  void _init() async {
    if (_postModel != null) {
      _postImageModels.clear();
      _contentController.text =
          AoLib.instance.htmlCharCodeToEmoji(_postModel?.content);
      _postImageModels.addAll(_postModel?.postImages ?? []);
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _userProvider.selectedPrivacy = _postModel?.privacy?.getPrivacy();
      _onContentChanged(_contentController.text);
    }
  }

  @override
  void dispose() {
    _contentNode.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged(String content) {
    _enablePost = (content.trim().isNotEmpty ||
        _postImages.isNotEmpty ||
        _postVideo != null);
    setState(() {});
  }

  void _post() async {
    if (!_enablePost) {
      _contentNode.requestFocus();
      return;
    }
    AoLib.instance.dismissKeyboard();
    final String content = _contentController.text.trim();

    if (_postModel != null) {
      _postModel?.content = content;
      _postModel?.privacy = context.selectedPrivacy.code;
      _editPost();
      return;
    }

    AoLib.instance.showLoading(context);
    CreatePostRes? createPostRes;
    if (_postVideo != null) {
      VideoUploadRes? videoUploadRes = await AppApi.instance.uploadVideo(
          token: context.token!,
          title: _postVideo?.name ?? '',
          video: _postVideo!);

      print('FROM VIEW ========> ${videoUploadRes.toString()}');

      if (videoUploadRes != null) {
        if (videoUploadRes.data?.videoId != null) {
          String type = _postVideo?.name.split('.').last ?? '';
          print(
              'id =========================> ${videoUploadRes?.data?.videoId}');
          VideoReq videoReq = VideoReq(
              videoId: videoUploadRes.data?.videoId,
              fileName: _postVideo?.name,
              mediableType: "post_video",
              fileType: 'video/$type',
              fileSize: await _postVideo?.length());
          createPostRes = await AppApi.instance.createPost(
              context: context, content: content, media: [], video: videoReq);
        }
      }
    } else {
      createPostRes = await AppApi.instance.createPost(
        context: context,
        content: content,
        media: _postImages,
      );
    }

    if (!mounted) return;
    if (createPostRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong");
      // Dismiss loading
      Navigator.of(context).pop();
      return;
    }
    if (!(createPostRes?.status ?? false)) {
      AoLib.instance.showSnack(
          context: context,
          message: createPostRes?.msg ?? "Something went wrong");
      // Dismiss loading
      Navigator.of(context).pop();
      return;
    }
    _postImages.clear();
    _postVideo = null;
    // Dismiss create post screen
    AoLib.instance.showSnack(context: context, message: "Successfully posted!");
    await _feedProvider.loadPosts(
        token: context.token, refresh: true, notifyEmpty: true);
    await _feedProvider.loadPosts(
        token: context.token,
        refresh: true,
        notifyEmpty: true,
        isMyArena: false);
    if (!mounted) return;
    // Dismiss loading
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppScreen(route: AppPageRoute.home),
        ));
  }

  void _editPost() async {
    if (_postModel == null) return;
    AoLib.instance.showLoading(context);

    if (deletedPhotosIdList.isNotEmpty) {
      for (PostImageModel postImage in deletedPhotosIdList) {
        final CreatePostRes? createPostRes = await AppApi.instance
            .deletePostMedia(context: context, postImage: postImage);

        _postModel?.postImages
            ?.removeWhere((element) => element.id == postImage.id);
      }
    }
    CreatePostRes? createPostRes;
    if (_postVideo != null) {
      VideoUploadRes? videoUploadRes = await AppApi.instance.uploadVideo(
          token: context.token!,
          title: _postVideo?.name ?? '',
          video: _postVideo!);

      print('FROM VIEW ========> ${videoUploadRes.toString()}');

      if (videoUploadRes != null) {
        if (videoUploadRes.data?.videoId != null) {
          String type = _postVideo?.name.split('.').last ?? '';
          print(
              'id =========================> ${videoUploadRes?.data?.videoId}');
          VideoReq videoReq = VideoReq(
              videoId: videoUploadRes.data?.videoId,
              fileName: _postVideo?.name,
              mediableType: "post_video",
              fileType: 'video/$type',
              fileSize: await _postVideo?.length());
          createPostRes = await AppApi.instance.editPost(
              context: context,
              post: _postModel!,
              media: [],
              video: videoReq);
        }
      }
    } else {
      createPostRes = await AppApi.instance
          .editPost(context: context, post: _postModel!, media: _postImages);
    }

    if (!mounted) return;
    // Dismiss loading
    Navigator.of(context).pop();
    _postImages.clear();
    if (createPostRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong");
      return;
    }
    AoLib.instance.showSnack(
        context: context, message: createPostRes.msg ?? "Something went wrong");
    if (createPostRes.status ?? false) {
      widget.onEditedCallback?.call(_postModel);
      Navigator.of(context).pop(_postModel);
    }
  }

  void _postImageDeleted(int index) {
    final PostImageModel postImage = _postImageModels[index];
    deletedPhotosIdList.add(postImage);
    setState(() {
      _postImageModels.removeAt(index);
    });

    // AoLib.instance.showConfirmDialog(
    //   context,
    //   title: "Remove media",
    //   content: "Are you sure you want to remove?",
    //   action: "Delete",
    //   onActionPressed: () async {
    //     AoLib.instance.showLoading(context);
    //     final CreatePostRes? createPostRes = await AppApi.instance
    //         .deletePostMedia(context: context, postImage: postImage);
    //     if (!mounted) return;
    //     Navigator.of(context).pop();
    //     if (createPostRes == null) {
    //       AoLib.instance
    //           .showSnack(context: context, message: "Something went wrong");
    //       return;
    //     }
    //     AoLib.instance.showSnack(
    //         context: context,
    //         message: createPostRes.msg ?? "Something went wrong");
    //     if (createPostRes.status ?? false) {
    //       setState(() {
    //         _postImageModels.removeAt(index);
    //       });
    //       _postModel?.postImages = _postImageModels;
    //     }
    //   },
    // );
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

  void _takePicture() async {
    AoLib.instance.dismissKeyboard();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (!mounted || photo == null) return;
    _postImages.add(photo);
    _postVideo = null;
    deleteVideoFromUrl();
    _onContentChanged(_contentController.text);
  }

  void _takeVideo() async {
    AoLib.instance.dismissKeyboard();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (!mounted || video == null) return;

    setState(() {
      if (_postModel != null) {
        deletedPhotosIdList.addAll(_postImageModels);
        _postImageModels.clear();
      }
      _postImages.clear();
      _postVideo = video;
    });

    print('FILE NAME ==========> ${video.name}');
    print('Size  ==========> ${await video.length()}');
    // final String extension = path.extension(postMedium.name);
    // print('Type ==========> ${}');
    int firstPoint = video.name.lastIndexOf('.');
    String type = video.name.split('.').last;

    print('Type ==========> video/$type');
    _onContentChanged(_contentController.text);
    print(deletedPhotosIdList.length);
    // Log.d(video.name);
    // AoLib.instance.showSnack(
    //   context: context,
    //   message: "Feature not implemented!",
    // );
  }

  void deleteVideoFromUrl() {
    if (_postImageModels.length == 1) {
      if (_postImageModels.first.mediableType == 'post_video') {
        deletedPhotosIdList.addAll(_postImageModels);
        _postImageModels.clear();
      }
    }
  }

  void _fromGallery() async {
    AoLib.instance.dismissKeyboard();
    List<XFile> images = [];

    final ImagePickerPlatform ipi = ImagePickerPlatform.instance;
    if (ipi is ImagePickerAndroid) {
      images = await ipi.getMultiImage() ?? [];
    } else {
      images = await _picker.pickMultiImage();
    }
    if (!mounted || images.isEmpty) return;
    _postImages.addAll(images);
    _postVideo = null;
    deleteVideoFromUrl();
    print("Image Count =================> ${_postImages.length}");
    _onContentChanged(_contentController.text);
  }

  void _moreMenu() async {}

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_postModel);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = context.watch();
    final UserProfileModel? userProfile = provider.userProfile;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kThemeWhite,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leading: IconButton(
            icon: SvgPicture.asset("assets/images/ic_cross.svg"),
            tooltip: "Back",
            highlightColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(_postModel),
          ),
          title: Text(
            "Write It",
            style: kTextStyle.copyWith(fontSize: 17),
          ),
          centerTitle: true,
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _post,
                child: Container(
                  width: 78,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Post",
                      style: kTextStyle.copyWith(
                        fontSize: 15,
                        color:
                            _enablePost ? Colors.black : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            kSpacerH,
          ],
        ),
        backgroundColor: kThemeAppBgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: AvatarWidget(
                      profileUrl: userProfile?.profileImageUrl,
                      size: 75,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 20, bottom: 7),
                          child: Text(
                            userProfile?.nickName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _changePrivacy,
                          child: const PostPrivacyStatusWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    TextField(
                      controller: _contentController,
                      focusNode: _contentNode,
                      cursorColor: kThemeTextColor,
                      style: kTextStyle.copyWith(
                        fontSize: 17,
                        color: kThemeSecTextColor,
                      ),
                      onChanged: _onContentChanged,
                      minLines: 1,
                      maxLines: 20,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'What are you thinking about...',
                        border: kTfNoBorder,
                        focusedBorder: kTfNoBorder,
                        enabledBorder: kTfNoBorder,
                        errorBorder: kTfNoBorder,
                        hintStyle: kTextStyle.copyWith(
                          fontSize: 17,
                          color: kThemeSecTextColor,
                        ),
                      ),
                    ),
                    if (_postImages.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: PostItemImagesWidget(
                          height: 300,
                          images: const [],
                          fileImages: _postImages,
                          onDelete: (int index) {
                            _postImages.removeAt(index);
                            setState(() {});
                          },
                          onImageClick: (_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreatePostGallery(
                                  xFileList: _postImages,
                                  onDelete: (index) {
                                    setState(() {
                                      _postImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (_postVideo != null)
                      SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              VideoItem(
                                isAutoPlay: false,
                                videoFile: File(_postVideo!.path),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      print('CALL NULL');
                                      _postVideo = null;
                                      print(_postVideo == null);
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.close),
                                  ),
                                ),
                              )
                            ],
                          )),
                    if (_postImageModels.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: PostItemImagesWidget(
                          height: 300,
                          images: _postImageModels,
                          fileImages: const [],
                          onDelete: _postImageDeleted,
                          onImageClick: (_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GalleryPhotoViewWrapper(
                                  postImageList: _postImageModels,
                                  mediaRawDataList: const [],
                                  xFileList: const [],
                                  initialIndex: _,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // if (_postModel == null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  children: [
                    IconButton(
                      onPressed: _takePicture,
                      icon: SvgPicture.asset('assets/images/ic_camera.svg'),
                    ),
                    kSpacerH,
                    IconButton(
                      onPressed: _takeVideo,
                      icon: SvgPicture.asset('assets/images/ic_video.svg'),
                    ),
                    kSpacerH,
                    IconButton(
                      onPressed: _fromGallery,
                      icon: SvgPicture.asset('assets/images/ic_gallery.svg'),
                    ),
                    kSpacerH,
                    Visibility(
                      // SEE MORE BUTTON
                      visible: false,
                      child: IconButton(
                        onPressed: _moreMenu,
                        icon: SvgPicture.asset('assets/images/ic_menu.svg'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
