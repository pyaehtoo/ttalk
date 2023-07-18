import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

import '../theme/color.dart';

class AuthDropdown extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Map<String, String> itemList;
  final Function(String) onChanged;
  final String initialValue;

  const AuthDropdown(
      {Key? key,
      required this.label,
      this.isRequired = false,
      required this.itemList,
      required this.onChanged,
      required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(itemList.entries);
    print(initialValue);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kSpacerV,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: label),
                if (isRequired)
                  TextSpan(
                    text: " *",
                    style:
                        kAuthLabelTextStyle.copyWith(color: kThemeAlertColor),
                  ),
              ],
              style: kAuthLabelTextStyle,
            ),
          ),
          const SizedBox(height: 7),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
            itemHeight: 55,
            value: initialValue,
            items: itemList.entries
                .map((entry) =>
                    DropdownMenuItem(value: entry.key, child: Text(entry.value)))
                .toList(),
            // items: itemList
            //     .map((value) =>
            //         DropdownMenuItem(value: value, child: Text(value)))
            //     .toList(),
            onChanged: (value) {
              onChanged(value ?? '');
            },
          )
        ],
      ),
    );
  }
}
