import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/app_btn.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final String cancel;
  final String action;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign textAlign;
  final Function()? onCancelled;
  final Function()? onAction;
  final Widget? prefixTitle;
  final Widget? subContent;
  final double height;

  const ConfirmDialogWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.cancel,
    required this.action,
    this.onCancelled,
    this.onAction,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textAlign = TextAlign.center,
    this.prefixTitle,
    this.height = 180,
    this.subContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Row(
            children: [
              prefixTitle ?? const SizedBox(),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: textAlign,
                  style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          kSpacerV,
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
            maxLines: 5,
            style: kTextStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: kThemeSecTextColor.withOpacity(0.8),
            ),
          ),
          kSpacerV,
          subContent ?? kSpacerV,
          kSpacerV,
          Row(
            children: [
              Expanded(
                child: AppButtonWidget(
                  text: 'Cancel',
                  background: kThemePrimaryColor.withOpacity(0.4),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancelled != null) onCancelled!();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: AppButtonWidget(
                  text: action,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onAction != null) onAction!();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
