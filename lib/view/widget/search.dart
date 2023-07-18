import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/text.dart';

import '../theme/dimens.dart';

class SearchWidget extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String q)? onSubmit;

  const SearchWidget({
    Key? key,
    this.hint = "Search",
    this.controller,
    this.focusNode,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kThemeWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 25,
            child: Image.asset(
              'assets/images/ic_buddy_search.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          kSpacerH,
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: kTextStyle,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              cursorColor: kThemeSecTextColor,
              onSubmitted: onSubmit,
              decoration: InputDecoration(
                hintText: hint,
                
                border: kTfNoBorder,
                hintStyle: kTextStyle.copyWith(
                  // color: kThemeTextColor.withOpacity(0.8),
                  color: kThemeTextColor,
                ),
                enabledBorder: kTfNoBorder,
                disabledBorder: kTfNoBorder,
                focusedBorder: kTfNoBorder,
                focusedErrorBorder: kTfNoBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
