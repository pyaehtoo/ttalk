// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/text.dart';

class CustomBottomNavbarWidget extends StatelessWidget {
  final int index;
  final Function(int index) onChanged;

  const CustomBottomNavbarWidget({
    Key? key,
    required this.index,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double navHeight = Platform.isAndroid ? 80 : 90;
    return Container(
      width: double.infinity,
      height: navHeight,
      decoration: const BoxDecoration(
        color: kThemeWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 20),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NavbarItemWidget(
            title: "Home",
            svgIcon: "ic_home.svg",
            active: index == 0,
            onClick: () => onChanged(0),
          ),
          NavbarItemWidget(
            title: "Buddy World",
            // svgIcon: "ic_group.svg",
            svgIcon: "ic_buddy_world.svg",
            active: index == 1,
            onClick: () => onChanged(1),
          ),
          NavbarItemWidget(
            title: "Write it",
            svgIcon: "write_it.svg",
            active: index == 2,
            onClick: () => onChanged(2),
          ),
          NavbarItemWidget(
            title: "Chat",
            svgIcon: "chat.svg",
            active: index == 3,
            onClick: () => onChanged(3),
          ),
          NavbarItemWidget(
            title: "Account",
            svgIcon: "account.svg",
            active: index == 4,
            onClick: () => onChanged(4),
          ),
        ],
      ),
    );
  }
}

class NavbarItemWidget extends StatelessWidget {
  final String title;
  final String svgIcon;
  final bool active;
  final Function() onClick;

  const NavbarItemWidget({
    Key? key,
    required this.title,
    required this.svgIcon,
    required this.active,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onClick,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/$svgIcon',
              color: active ? kThemePrimaryColor : kThemeTextColor,
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(
                
                fontSize: 12,
                color: kThemeSecTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
