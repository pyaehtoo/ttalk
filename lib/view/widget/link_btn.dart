import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/text.dart';

TextSpan linkButtonWidget(String title, Function onPressed,
    {bool underline = true, Color color = kThemeColor}) {
  return TextSpan(
    text: title,
    onEnter: (_) => onPressed(),
    
    recognizer: TapGestureRecognizer()..onTap = () => onPressed(),
    style: kTextStyle.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: color.withAlpha(170),
      color: color,
    ),
  );
}
