import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/video_load_res.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/widget/video_item.dart';
import 'package:teatalk/view/widget/video_player.dart';

import '../../model/post.dart';
import '../../network/res/media_res.dart';
import '../../util/constant.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  const GalleryPhotoViewWrapper({
    Key? key,
    this.initialIndex = 0,
    required this.postImageList,
    this.mediaRawDataList = const [],
    this.xFileList = const [],
    this.scrollDirection = Axis.horizontal,
  }) : super(key: key);

  final int initialIndex;
  final List<PostImageModel> postImageList;
  final List<MediaRawData> mediaRawDataList;
  final List<XFile> xFileList;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  final List<String> _imageList = [];
  final List<int?> _ids = [];
  final List<String> _prefix = [];
  final List<String> _types = [];
  late int currentIndex = widget.initialIndex;
  late PageController _pageController;
  List<String> imageLink = [];
  List<VideoLoadVO?> videoList = [];
  bool _isXFile = false;
  bool _isPostImageList = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    for (final element in widget.postImageList) {
      _imageList.add(element.filePath!);
      _ids.add(element.id);
      _prefix.add(element.heroPrefix ?? "_");
      _types.add(element.mediableType ?? '');
    }
    for (final element in widget.mediaRawDataList) {
      _imageList.add(element.filePath!);
      _ids.add(element.postId);
      _prefix.add(element.heroPrefix ?? "_");
      _types.add('');
    }
    _isXFile = widget.xFileList.isNotEmpty;
    for (final element in widget.xFileList) {
      _imageList.add(element.path);
    }
    _isPostImageList = ((widget.postImageList.isNotEmpty) &&
        (widget.mediaRawDataList.isEmpty));

    getImageLink();
    print('Image Length from gallery ======> ${_imageList.length}');
  }

  Future<void> getImageLink() async {
    for (PostImageModel postMedia in widget.postImageList) {
      print('Post media Type ==============> ${postMedia.mediableType}');
      if (postMedia.mediableType == 'post_video') {
        print(postMedia.filePath);
        await AppApi.instance
            .getVideoUrl(videoId: postMedia.filePath ?? '')
            .then((videoLoadRes) {
          imageLink.add(videoLoadRes?.data?.videoMeta?.coverUrl ?? '');
          videoList.add(videoLoadRes?.data ?? VideoLoadVO());
        });
      } else {
        imageLink.add(kTempImageHost + (postMedia.filePath ?? ''));
        videoList.add(null);
      }
    }

    for (String image in _imageList) {
      imageLink.add(kTempImageHost + image);
    }
    print(_types);
    print(imageLink);
    print(videoList);

    setState(() {});
  }

  void onPageChanged(int index) {
    if (mounted) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: kThemeBgColor),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        height: double.infinity,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                child: PageView.builder(
                  itemCount: _imageList.length,
                  itemBuilder: (context, index) {
                    final String item = _imageList[index];

                    String? videoId;
                    if (!_isXFile) {
                      if (_isPostImageList) {
                        videoId = widget.postImageList[index].filePath;
                      }
                    }

                    return Stack(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: (_isXFile)
                                ? Image.file(File(item), fit: BoxFit.cover)
                                : (imageLink.isEmpty)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : (_types[index] == 'post_video')
                                        ? VideoItem(
                                            videoUrl:
                                                videoList[index]?.videoUrl,
                                          )
                                        : 
                                        Image.network(
                                            imageLink[index],
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: Colors.grey,
                                              child: Text(error.toString()),
                                            ),
                                          )

                            // CachedNetworkImage(
                            //     imageUrl: imageLink[index],
                            //     errorWidget: (context, url, error) {
                            //       return Container(
                            //         color: Colors.grey,
                            //         child: Text(error.toString()),
                            //       );
                            //     },
                            //   ),
                            ),
                        Align(
                          alignment: Alignment.center,
                          child: Visibility(
                            visible: _types[index] == 'post_video',
                            child: GestureDetector(
                              onTap: () {
                                if (_types[index] == 'post_video') {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(
                                            videoLoadVO: videoList[index],
                                          )));
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    size: 35,
                                    color: Colors.black45,
                                  )),
                            ),
                          ),
                        )
                      ],
                    );

                    //     return _isXFile
                    // ? Container(child:  Image.file(File(item), fit: BoxFit.cover).image,)
                    // : CachedNetworkImageProvider(kTempImageHost + item);
                  },
                ),
              ),
            ),
            // PhotoViewGallery.builder(
            //   scrollPhysics: const BouncingScrollPhysics(),
            //   builder: _buildItem,
            //   itemCount: _imageList.length,
            //   backgroundDecoration: const BoxDecoration(color: kThemeBgColor),
            //   pageController: _pageController,
            //   onPageChanged: onPageChanged,
            //   scrollDirection: widget.scrollDirection,

            // ),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SvgPicture.asset(
                    'assets/images/ic_remove.svg',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = _imageList[index];
    int? id = 0;
    if (!_isXFile) {
      id = _ids[index];
    }

    return PhotoViewGalleryPageOptions(
      imageProvider: _isXFile
          ? Image.file(File(item), fit: BoxFit.cover).image
          : NetworkImage(kTempImageHost + item),
      //  CachedNetworkImageProvider(kTempImageHost + item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 1.0,
      maxScale: PhotoViewComputedScale.covered * 2.5,
      heroAttributes: _isXFile
          ? null
          : PhotoViewHeroAttributes(
              tag: "${_prefix[index]}_${id}_post_image_$item"),
    );
  }
}
