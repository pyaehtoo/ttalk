import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/util/constant.dart';

class LogoWidget extends StatelessWidget {
  final Alignment alignment;
  final double width;
  final String tag;

  const LogoWidget({
    Key? key,
    this.tag = "${kAppName}AuthLogo",
    this.alignment = Alignment.center,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Align(
        alignment: alignment,
        child: Hero(
          tag: tag,
          child: SizedBox(
            width: width,
            height: 50,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
