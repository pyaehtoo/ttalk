import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';

import '../theme/text.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color fontColor;

  const PrimaryButtonWidget(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.fontColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          color: kThemeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        height: 54,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kTextStyle.copyWith(
                fontSize: 17, fontWeight: FontWeight.bold, color: fontColor),
          ),
        ),
      ),
    );
  }
}
