import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/util/extension.dart';

import '../theme/text.dart';
import 'avatar.dart';

class DiaryProfileWidget extends StatelessWidget {
  final UserProfileModel? userProfile;
  final bool isLoginUser;
  final bool isEdit;
  final Function()? onProfileChanged;
  final Function()? onCoverChanged;
  final XFile? pickedProfileImage;
  final XFile? pickedCoverImage;

  const DiaryProfileWidget({
    Key? key,
    required this.userProfile,
    this.isEdit = false,
    this.isLoginUser = true,
    this.onProfileChanged,
    this.onCoverChanged,
    this.pickedProfileImage,
    this.pickedCoverImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          (pickedCoverImage != null)
              ? Image.file(
                  File(
                    pickedCoverImage?.path ?? '',
                  ),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                )
              : (userProfile?.coverImageUrl?.isNullOrEmpty ?? true)
                  ? Container(color: Colors.grey.shade300)
                  : Image.network(
                      userProfile?.coverImageUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey.shade300),
                    ),
          // CachedNetworkImage(
          //     imageUrl: userProfile?.coverImageUrl ?? '',
          //     placeholder: (c, s) =>
          //         Container(color: Colors.grey.shade300),
          //     errorWidget: (c, s, d) =>
          //         Container(color: Colors.grey.shade300),
          //     width: double.infinity,
          //     height: double.infinity,
          //     fit: BoxFit.cover,
          //   ),
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.black.withOpacity(0.01),
          //         Colors.black.withOpacity(0.04),
          //         Colors.black.withOpacity(0.05),
          //         Colors.black.withOpacity(0.08),
          //         Colors.black.withOpacity(0.1),
          //         Colors.black.withOpacity(0.2),
          //         Colors.black.withOpacity(0.3),
          //         Colors.black.withOpacity(0.4),
          //         Colors.black.withOpacity(0.5),
          //       ],
          //     ),
          //   ),
          // ),
          if (isLoginUser && isEdit)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: onCoverChanged,
                  child: SvgPicture.asset(
                    'assets/images/ic_camera_plus.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
          Container(
            height: 110,
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: AvatarWidget(
                          profileUrl: userProfile?.profileImageUrl,
                          profileFilePath: pickedProfileImage?.path,
                          size: 70,
                          displayBorder: true,
                        ),
                      ),
                      Visibility(
                        visible: isLoginUser && isEdit,
                        child: Positioned(
                          bottom: -12,
                          left: 0,
                          right: 0,
                          child: InkWell(
                            onTap: onProfileChanged,
                            child: SvgPicture.asset(
                              'assets/images/ic_camera_plus.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        userProfile?.nickName ?? 'Loading',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                            shadows: textShadow),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        "@${userProfile?.uniqueName ?? 'loading'}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.white70,
                            shadows: textShadowSmall),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              right: 15,
              child: Text(
                'Posts ${userProfile?.postCount ?? 0}   Buddies ${userProfile?.friendCount ?? 0}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
              ))
        ],
      ),
    );
  }
}
