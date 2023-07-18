import 'package:flutter/material.dart';

import 'package:teatalk/view/theme/color.dart';

const TextStyle kTextStyle =
    TextStyle(color: kThemeTextColor, fontFamily: 'Graphie');
const TextStyle kAuthLabelTextStyle = TextStyle(
  color: kThemeTextColor,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  // fontFamily: 'Graphie',
);
const kTfNoBorder =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
const InputDecoration kInputDecoration = InputDecoration(
  border: kTfNoBorder,
  enabledBorder: kTfNoBorder,
  disabledBorder: kTfNoBorder,
  focusedBorder: kTfNoBorder,
  focusedErrorBorder: kTfNoBorder,
);

const List<Shadow> textShadow = [
  Shadow(
      // bottomLeft
      offset: Offset(-1, -1),
      color: Colors.black),
  Shadow(
      // bottomRight
      offset: Offset(1, -1),
      color: Colors.black),
  Shadow(
      // topRight
      offset: Offset(1, 1),
      color: Colors.black),
  Shadow(
      // topLeft
      offset: Offset(-1, 1),
      color: Colors.black),
];

const List<Shadow> textShadowSmall = [
  Shadow(
      // bottomLeft
      offset: Offset(-0.2, -0.2),
      color: Colors.black),
  Shadow(
      // bottomRight
      offset: Offset(0.2, -0.2),
      color: Colors.black),
  Shadow(
      // topRight
      offset: Offset(0.2, 0.2),
      color: Colors.black),
  Shadow(
      // topLeft
      offset: Offset(-0.2, 0.2),
      color: Colors.black),
];
