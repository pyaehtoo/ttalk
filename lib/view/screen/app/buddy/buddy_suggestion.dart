import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/find_buddy_res.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

import '../../../theme/color.dart';
import '../../../widget/buddy_item.dart';
import '../../../widget/search.dart';

class BuddySuggestionScreen extends StatefulWidget {
  final String? searchKey;
  const BuddySuggestionScreen({Key? key, this.searchKey}) : super(key: key);

  @override
  State<BuddySuggestionScreen> createState() => _BuddySuggestionScreenState();
}

class _BuddySuggestionScreenState extends State<BuddySuggestionScreen> {
  final TextEditingController _controller = TextEditingController();
  List<FindBuddyData> _list = [];

  @override
  void initState() {
    super.initState();
    if (widget.searchKey != null) {
      _controller.text = widget.searchKey!;
    }
    _loadData(delay: true);
  }

  void _loadData({bool delay = false}) async {
    if (delay) await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    AoLib.instance.showLoading(context);
    final FindBuddyRes? apiRes = await AppApi.instance
        .findBuddy(context: context, search: _controller.text);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (apiRes == null) {
      AoLib.instance
          .showSnack(context: context, message: 'Something went wrong.');
      return;
    }
    setState(() => _list = apiRes.data ?? []);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kThemeWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.searchKey != null ? "Buddy Search" : "Buddy Suggestion",
          style: kTextStyle.copyWith(fontSize: 17),
        ),
        centerTitle: false,
      ),
      backgroundColor: kThemeAppBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kAppGapDimens, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchWidget(
                    controller: _controller,
                    hint: "Search buddy",
                    onSubmit: (_) => _loadData(),
                  ),
                  const SizedBox(height: 20),
                  Text("Found ${_list.length} buddies"),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: kAppGapDimens,
                  right: 12,
                  bottom: 50,
                ),
                itemBuilder: (c, i) {
                  final item = _list[i];
                  return BuddyItemWidget(
                    buddy: item.getBuddyModel(),
                    findBuddyData: item,
                  );
                },
                separatorBuilder: (c, i) {
                  return const Padding(
                    padding: EdgeInsets.only(right: kAppGapDimens - 12),
                    child: Divider(height: 10),
                  );
                },
                itemCount: _list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
