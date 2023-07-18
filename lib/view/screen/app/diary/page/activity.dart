import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../../../../../network/res/activities_res.dart';
import '../../../../theme/color.dart';

class DiaryActivityPage extends StatefulWidget {
  final List<ActivityData> list;

  const DiaryActivityPage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<DiaryActivityPage> createState() => _DiaryActivityPageState();
}

class _DiaryActivityPageState extends State<DiaryActivityPage> {
  final List<String> _filteredDate = [];
  final Map<String, List<ActivityData>> _filterActivities = {};

  @override
  void initState() {
    super.initState();
    final DateFormat dateFormat = DateFormat("MMM dd, yyyy");
    for (final ActivityData activityData in widget.list) {
      final date = DateTime.parse(activityData.createdAt);
      final String formattedDate = dateFormat.format(date);
      if (!_filteredDate.contains(formattedDate)) {
        _filteredDate.add(formattedDate);
      }
      final List<ActivityData> tmpList = _filterActivities[formattedDate] ?? [];
      tmpList.add(activityData);
      _filterActivities[formattedDate] = tmpList;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) return const SizedBox();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: kThemeWhite,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _filteredDate.length,
        itemBuilder: (context, index) {
          final String formattedDate = _filteredDate[index];
          final List<ActivityData> tmpActivities =
              _filterActivities[formattedDate] ?? [];
          return StickyHeader(
            header: Container(
              color: kThemeWhite,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                formattedDate,
                style: kTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            content: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              itemCount: tmpActivities.length,
              itemBuilder: (c, i) {
                final ActivityData activityData = tmpActivities[i];
                final date = DateTime.parse(activityData.createdAt);
                return InkWell(
                  onTap: () {
                    AoLib.instance.showSnack(
                      context: context,
                      message: "${activityData.description}\n$date",
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            activityData.description,
                            style: kTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        kSpacerH,
                        Timeago(
                          builder: (c, s) {
                            return Text(
                              "$s ago",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: kTextStyle.copyWith(
                                fontSize: 12,
                                color: kThemeSecTextColor,
                              ),
                            );
                          },
                          locale: 'en_short',
                          date: date,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
