import 'package:flutter/material.dart';
import 'package:teatalk/network/res/sticker_per_post_res.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/view/screen/app/page/account.dart';
import 'package:teatalk/view/widget/avatar.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class StickerItem extends StatefulWidget {
  final StickerPerPost sticker;
  const StickerItem({super.key, required this.sticker});

  @override
  State<StickerItem> createState() => _StickerItemState();
}

class _StickerItemState extends State<StickerItem> {
  String _profileUrl = '';
  String _userName = '';
  String _stickerUrl = '';
  int _iceCubeCount = 0;
  String _createAt = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileUrl = widget.sticker.sentUser?.profile?.profileImageUrl ?? '';
    _userName = widget.sticker.sentUser?.nickName ?? '';
    _stickerUrl = widget.sticker.stickerUrl ?? '';
    _iceCubeCount = widget.sticker.stickerAmount ?? 0;
    _createAt = widget.sticker.createAt ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWidget(
                profileUrl: _profileUrl,
                size: 24,
              ),
              const SizedBox(
                width: 14,
              ),
              Text(
                _userName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Graphie',
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          StickerView(
            stickerUrl: _stickerUrl,
            createdAt: _createAt,
            iceCount: _iceCubeCount,
          )
        ],
      ),
    );
  }
}

class StickerView extends StatelessWidget {
  const StickerView(
      {super.key,
      required this.stickerUrl,
      required this.createdAt,
      required this.iceCount});

  final String stickerUrl;
  final String createdAt;
  final int iceCount;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(createdAt);
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            stickerUrl,
            width: 150,
          ),
          const SizedBox(
            height: 8,
          ),
          IceCubeCount(
            count: iceCount.toString(),
            iceCubeSize: 17,
            fontSize: 13,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Timeago(
                  builder: (context, value) {
                    return Text(
                      (value == 'now') ? "just now" : value.replaceAll("~", ""),
                      style:
                          const TextStyle(fontFamily: 'Graphie', fontSize: 13),
                    );
                  },
                  date: dateTime),
              // const Text(
              //   ' | ',
              //   style: TextStyle(fontFamily: 'Graphie', fontSize: 13),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     AoLib.instance.showToast('Feature Not Availabe Now');
              //   },
              //   child: const Text(
              //     'Like',
              //     style: TextStyle(fontFamily: 'Graphie', fontSize: 13),
              //   ),
              // ),
              // const Text(
              //   ' | ',
              //   style: TextStyle(fontFamily: 'Graphie', fontSize: 13),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     AoLib.instance.showToast('Feature Not Availabe Now');
              //   },
              //   child: const Text(
              //     'Reply',
              //     style: TextStyle(fontFamily: 'Graphie', fontSize: 13),
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
