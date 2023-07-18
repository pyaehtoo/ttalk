import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';

import '../theme/text.dart';

class AppButtonWidget extends StatelessWidget {
  final String text;
  final Function onPressed;
  final double width;
  final double height;
  final Color background;
  final Color fontColor;
  final bool isBorder;
  final double fontSize;

  const AppButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontColor = Colors.black,
    this.width = double.infinity,
    this.height = 42,
    this.background = kThemePrimaryColor,
    this.isBorder = true,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(5),
          border: isBorder ? Border.all(color: background, width: 2) : null,
        ),
        padding: const EdgeInsets.only(top: 1.5),
        width: width,
        height: height,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: kTextStyle.copyWith(
                fontSize: fontSize, fontWeight: FontWeight.w500, color: fontColor),
          ),
        ),
      ),
    );
  }
}
