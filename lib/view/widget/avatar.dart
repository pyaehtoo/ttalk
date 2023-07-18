import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../util/constant.dart';
import '../theme/color.dart';

class AvatarWidget extends StatelessWidget {
  final String? profileUrl;
  final String? profileFilePath;
  final double size;
  final bool displayBorder;

  const AvatarWidget({
    Key? key,
    required this.profileUrl,
    this.profileFilePath,
    this.size = 90,
    this.displayBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: kThemeWhite,
        borderRadius: BorderRadius.circular(size / 2),
        border:
            displayBorder ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: (profileFilePath != null)
            ? Image.file(
                File(profileFilePath ?? ''),
                fit: BoxFit.cover,
              )
            : Image.network(profileUrl ?? kDefaultAvatar,fit: BoxFit.cover,)
            
            // CachedNetworkImage(
            //     fit: BoxFit.cover,
            //     imageUrl: profileUrl ?? kDefaultAvatar,
            //     placeholder: (c, _) =>
            //         const CircularProgressIndicator(color: kThemeColor),
            //     errorWidget: (c, _, __) => Container(
            //         color: kThemePrimaryColor,
            //         child: const Icon(Icons.error_outline, color: Colors.red)),
            //   ),
      ),
    );
  }
}
