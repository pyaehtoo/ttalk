import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/util/post_privacy.dart';

import '../../provider/user.dart';
import '../theme/color.dart';
import '../theme/text.dart';

class PostPrivacyStatusWidget extends StatelessWidget {
  final double width;
  final double logoSize;
  final double fontSize;
  const PostPrivacyStatusWidget({Key? key, this.width = 100,  this.logoSize = 17,  this.fontSize = 12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = context.watch();
    final PostPrivacy privacy = provider.selectedPrivacy;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: kThemeAppBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black54),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      child: Row(
        children: [
          SizedBox(
            width: logoSize,
            height: logoSize,
            child: SvgPicture.asset(privacy.svgPath),
          ),
          Expanded(
            child: Text(
              privacy.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(
                color: kThemeTextColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: logoSize,
            height: logoSize,
            child: SvgPicture.asset('assets/images/ic_caret_down.svg'),
          ),
        ],
      ),
    );
  }
}
