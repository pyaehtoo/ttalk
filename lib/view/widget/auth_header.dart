import 'package:flutter/material.dart';

import '../theme/dimens.dart';
import '../theme/text.dart';
import 'logo.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;

  const AuthHeaderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 44),
        const LogoWidget(alignment: Alignment.centerLeft),
        const SizedBox(height: 40),
        Text(title, style: kTextStyle.copyWith(fontSize: 25)),
        kSpacerV,
      ],
    );
  }
}
