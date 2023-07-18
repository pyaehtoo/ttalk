import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final String? videoUrl;
  final File? videoFile;
  final bool isAutoPlay;
  const VideoItem(
      {Key? key, this.videoUrl, this.videoFile, this.isAutoPlay = false})
      : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    }

    if (widget.videoFile != null) {
      _controller = VideoPlayerController.file(widget.videoFile!);
    }

    _controller.initialize().then((value) {
      setState(() {
        _chewieController = ChewieController(
            videoPlayerController: _controller,
            aspectRatio: _controller.value.aspectRatio,
            autoPlay: widget.isAutoPlay,
            allowFullScreen: true,
            allowPlaybackSpeedChanging: true,
            looping: true,
            draggableProgressBar: true,
            showControls: true);
      });
    });
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
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Chewie(controller: _chewieController),
          )
        : const SizedBox.shrink();
  }
}
