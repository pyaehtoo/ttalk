import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart'
    as pub_date_picker;
import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime dateTime;
  final Function(DateTime) onChanged;

  const DatePickerWidget(
      {Key? key, required this.onChanged, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kSpacerV,
          kSpacerV,
          Text(
            "Set Date",
            style: kTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          kSpacerV,
          Expanded(
            child: pub_date_picker.DatePickerWidget(
              onMonthChangeStartWithFirstDate: false,
              dateFormat: 'MMM/dd/yyyy',
              onChange: (_, __) => onChanged(_),
              maxDateTime:
                  DateTime.now().subtract(const Duration(days: 365 * 13)),
              initialDateTime: dateTime,
              pickerTheme: pub_date_picker.DateTimePickerTheme(
                showTitle: false,
                itemTextStyle: kTextStyle.copyWith(fontSize: 16),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "CANCEL",
                  style: kTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              kSpacerH,
              TextButton(
                onPressed: () => Navigator.of(context).pop("set"),
                child: Text(
                  "SET",
                  style: kTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
