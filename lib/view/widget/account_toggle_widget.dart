import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/dimens.dart';
import '../theme/text.dart';

class AccountToggleButtonWidget extends StatefulWidget {
  final String icon;
  final String title;
  final Function() onPressed;
  final Widget? child;
  final bool isSubChild;

  const AccountToggleButtonWidget(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed,
      this.child,
      this.isSubChild = false})
      : super(key: key);

  @override
  State<AccountToggleButtonWidget> createState() =>
      _AccountToggleButtonWidgetState();
}

class _AccountToggleButtonWidgetState extends State<AccountToggleButtonWidget> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    final Widget? child = widget.child;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0),
            top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0)),
      ),
      constraints: const BoxConstraints(
        minHeight: 50,
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (child != null) {
                    setState(() => _show = !_show);
                    return;
                  }
                  widget.onPressed();
                },
                child: Padding(
                  padding:
                       EdgeInsets.symmetric(vertical: 10, horizontal: widget.isSubChild ? 50 : 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset(widget.icon),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: kTextStyle,
                        ),
                      ),
                      if (child != null)
                        Icon(_show
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                // alignment: Alignment.topLeft,
                duration: const Duration(milliseconds: 300),
                child: child != null && _show
                    ? Container(color: Colors.red, child: child)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
