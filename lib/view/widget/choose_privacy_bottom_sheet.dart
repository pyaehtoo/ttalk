import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/post_privacy.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

class ChoosePrivacyBottomSheet extends StatelessWidget {
  const ChoosePrivacyBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = context.watch();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17) +
            EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: SvgPicture.asset('assets/images/ic_bar.svg'),
            ),
            const SizedBox(height: 30),
            Text(
              "Who can see this post?",
              style: kTextStyle.copyWith(fontSize: 16),
            ),
            kSpacerV,
            Text(
              "Your post will be visible feed, on your profile and in search results",
              style: kTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 20),
            PrivacyItemWidget(
              privacy: PostPrivacy.public,
              onPressed: (_) => provider.selectedPrivacy = _,
            ),
            PrivacyItemWidget(
              privacy: PostPrivacy.friend,
              onPressed: (_) => provider.selectedPrivacy = _,
            ),
            PrivacyItemWidget(
              privacy: PostPrivacy.onlyMe,
              onPressed: (_) => provider.selectedPrivacy = _,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class PrivacyItemWidget extends StatelessWidget {
  final PostPrivacy privacy;
  final Function(PostPrivacy) onPressed;

  const PrivacyItemWidget({
    Key? key,
    required this.privacy,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = context.watch();
    final bool isSelected = provider.selectedPrivacy == privacy;
    final String status = isSelected ? 'active' : 'inactive';
    return InkWell(
      onTap: () => onPressed(privacy),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: SvgPicture.asset(privacy.svgPath),
            ),
            kSpacerH,
            Expanded(
              child: Text(
                privacy.name,
                style: kTextStyle.copyWith(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 18,
              height: 18,
              child: SvgPicture.asset("assets/images/ic_radio_$status.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
