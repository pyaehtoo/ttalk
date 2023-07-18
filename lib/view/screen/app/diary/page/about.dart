import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

class DiaryAboutPage extends StatelessWidget {
  final UserProfileModel? userProfile;

  const DiaryAboutPage({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) return const SizedBox();
    final AppProvider appProvider = context.read();
    final DateFormat dateFormat = DateFormat("yyyy MMMM dd");
    final DateTime? birthdate =
        DateTime.tryParse(userProfile!.birthDate ?? '-');
    final String? city = appProvider.findLocationById(userProfile!.city)?.name;
    final String? region =
        appProvider.findLocationById(userProfile!.hometown)?.name;
    bool isLoggedInUser = (userProfile?.userId == context.userId);
    String moreAboutText = (isLoggedInUser)
        ? "More About Me"
        : "More About ${userProfile?.nickName}";
    return SingleChildScrollView(
      child: Column(
        children: [
          Visibility(
            visible: userProfile?.bio?.isNotEmpty ?? false,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
              decoration: BoxDecoration(
                color: kThemeWhite,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoggedInUser ? "My Bio" : "Bio",
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    userProfile!.bio ?? '',
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 5,
              bottom: 15,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            decoration: BoxDecoration(
              color: kThemeWhite,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moreAboutText,
                  style: kTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 13),
                Visibility(
                  visible: isLoggedInUser,
                  child: MoreAboutMeText(
                    leadText: "Account ID",
                    dataText: userProfile?.imsAccountId?.toString() ?? '',
                  ),
                ),
                MoreAboutMeText(
                  leadText: "Public Username",
                  dataText: userProfile?.nickName ?? '',
                ),
                Visibility(
                  visible: birthdate != null,
                  child: MoreAboutMeText(
                    leadText: "Date of Birth",
                    dataText:
                        birthdate != null ? dateFormat.format(birthdate) : "-",
                  ),
                ),
                Visibility(
                  visible: userProfile!.maritalStatus?.isNotEmpty ?? false,
                  child: MoreAboutMeText(
                    leadText: "Martial Status",
                    dataText:
                        userProfile!.maritalStatus?.firstLetterCapitalize() ??
                            '',
                  ),
                ),
                Visibility(
                  visible: city != null,
                  child: MoreAboutMeText(
                    leadText: "City",
                    dataText: city ?? '',
                  ),
                ),
                Visibility(
                  visible: region != null,
                  child: MoreAboutMeText(
                    leadText: "Region",
                    dataText: region ?? '',
                  ),
                ),
                Visibility(
                  visible: userProfile?.gender?.isNotEmpty ?? false,
                  child: MoreAboutMeText(
                    leadText: "Gender",
                    dataText: userProfile?.gender ?? '',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoreAboutMeText extends StatelessWidget {
  final String leadText;
  final String dataText;
  const MoreAboutMeText({
    super.key,
    required this.leadText,
    required this.dataText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              leadText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: kTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            dataText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
