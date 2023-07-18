import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';

class IconAndTextButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  const IconAndTextButton(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 100,
        height: 100,
        color: kThemePrimaryColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: Colors.white),
              const SizedBox(
                height: 8,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
