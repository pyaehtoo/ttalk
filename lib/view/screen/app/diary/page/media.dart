import 'package:flutter/material.dart';
import 'package:teatalk/view/widget/post_item.dart';

import '../../../../../network/res/media_res.dart';
import '../../../../theme/color.dart';
import '../../../../theme/text.dart';
import '../../../../widget/gallery_view_wrapper.dart';

class DiaryMediaPage extends StatelessWidget {
  final Function(List<MediaRawData>, int, bool) onTapImage;
  final MediaData? mediaData;
  final bool isBuddy;
  const DiaryMediaPage({
    Key? key,
    required this.mediaData,
    required this.onTapImage,
    this.isBuddy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaData == null) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kThemeWhite,
        borderRadius: BorderRadius.circular(4),
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: isBuddy ? kThemePrimaryColor : kThemeTextColor,
              unselectedLabelColor: isBuddy ? Colors.black : null,
              indicatorColor: (isBuddy) ? Colors.transparent : kThemeColor,
              isScrollable: true,
              labelStyle: kTextStyle.copyWith(
                fontSize: isBuddy ? 12 : 13,
                color: kThemeTextColor,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: "Profile Pictures"),
                Tab(text: "Cover Images"),
                Tab(text: "Photos"),
                Tab(text: "Videos"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DiaryMediaGridViewWidget(
                    list: mediaData?.profileMedias ?? [],
                    onTapImage: (imageList, selectedIndex) {
                      onTapImage(imageList, selectedIndex, true);
                    },
                  ),
                  DiaryMediaGridViewWidget(
                    list: mediaData?.coverMedias ?? [],
                    onTapImage: (imageList, selectedIndex) {
                      onTapImage(imageList, selectedIndex, true);
                    },
                  ),
                  DiaryMediaGridViewWidget(
                    list: mediaData?.postMedias ?? [],
                    onTapImage: (imageList, selectedIndex) {
                      onTapImage(imageList, selectedIndex, false);
                    },
                  ),
                  DiaryMediaGridViewWidget(
                    list: mediaData?.videoMedias ?? [],
                    onTapImage: (imageList, selectedIndex) {
                      onTapImage(imageList, selectedIndex, false);
                    },
                    isVideo: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiaryMediaGridViewWidget extends StatelessWidget {
  final Function(List<MediaRawData>, int) onTapImage;
  final List<MediaRawData> list;
  final bool isVideo;

  const DiaryMediaGridViewWidget({
    Key? key,
    required this.list,
    required this.onTapImage,
    this.isVideo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 100,
        ),
        itemCount: list.length,
        itemBuilder: (c, i) {
          if (isVideo) return const SizedBox();
          final MediaRawData mediaRawData = list[i];
          return CachedPostImageWidget(
            image: null,
            mediaRawData: mediaRawData,
            onPressed: () {
              onTapImage(list, i);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => GalleryPhotoViewWrapper(
              //       postImageList: const [],
              //       mediaRawDataList: list,
              //       initialIndex: i,
              //       scrollDirection: Axis.horizontal,
              //     ),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
