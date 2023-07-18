import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/video_load_res.dart';

import 'package:teatalk/view/theme/color.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoId;
  final VideoLoadVO? videoLoadVO;
  const VideoPlayerScreen({
    Key? key,
    this.videoId,
    this.videoLoadVO,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  String videoUrl = '';
  String coverUrl = '';
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    if (widget.videoLoadVO != null) {
      videoUrl = widget.videoLoadVO?.videoUrl ?? '';
      print(videoUrl);
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoInitialize: true,
          autoPlay: true,
          allowFullScreen: true,
          // aspectRatio: 16 / 9,
          allowPlaybackSpeedChanging: true,
          looping: true,
          draggableProgressBar: true,
          showControls: true);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
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
                  constraints: BoxConstraints(),
                  height: 300,
                  child: Chewie(controller: _chewieController)),
            ),
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
}
