import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teatalk/view/theme/text.dart';

const Color kThemeWhite = Colors.white;
const Color kThemeBgColor = Color(0xffF8F8F8);
const Color kThemeAppBgColor = Color.fromRGBO(242, 242, 242, 1);
const Color kThemeTextColor = Color(0xff2F2E41);
const Color kThemeSecTextColor = Color(0xff323232);
const Color kThemeColor = Color(0xffF8AB4F);
const Color kThemePrimaryColor = Color(0xffF7941D);
const Color kThemeBorderColor = Color(0xff848484);
const Color kThemeAlertColor = Color(0xffEB5757);
const Color kNotiUnreadColor = Color.fromRGBO(231, 199, 137, 0.28);
const Color ksearchBgColor = Color.fromRGBO(132, 132, 132, 0.12);
const Color kThemeUnselectedColor = Color.fromRGBO(248, 171, 79, 0.2);
const Color kBuddyProfileNameTextColor = Color.fromRGBO(28, 28, 28, 1);
// const Color kCommentBgColor = Color(0xffF7941D).withOpacity(0.2);
const Color kCommentBgColor = Color.fromRGBO(247, 148, 29, 0.2);
final ThemeData kAppTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: kThemeBgColor,
  // fontFamily: 'Graphie',
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    iconTheme: IconThemeData(color: kThemeTextColor),
    toolbarTextStyle: kTextStyle,
    backgroundColor: kThemeWhite,
    elevation: 0.5,
    centerTitle: false,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kThemeWhite,
    type: BottomNavigationBarType.fixed,
  ),
);
