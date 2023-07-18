import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

import '../../../../network/res/buddy_req_list_res.dart';
import '../../../theme/color.dart';
import '../../../widget/buddy_item.dart';
import '../../../widget/search.dart';

class BuddySentRequestScreen extends StatefulWidget {
  const BuddySentRequestScreen({Key? key}) : super(key: key);

  @override
  State<BuddySentRequestScreen> createState() => _BuddySentRequestScreenState();
}

class _BuddySentRequestScreenState extends State<BuddySentRequestScreen> {
  final TextEditingController _controller = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<BuddyReqListData> _list = [];

  @override
  void initState() {
    super.initState();
  }

  void _loadData() async {
    final BuddyReqListRes? apiRes =
        await AppApi.instance.getBuddyRequestedList(context: context);
    if (!mounted) return;
    _refreshController.refreshCompleted();
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
    _refreshController.dispose();
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
          "Buddy Ups",
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
                  // SearchWidget(
                  //   controller: _controller,
                  //   hint: "Search buddy",
                  // ),
                  // const SizedBox(height: 20),
                  Text("You have sent ${_list.length} buddy ups."),
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _loadData,
                enablePullDown: true,
                enablePullUp: false,
                header: const WaterDropHeader(waterDropColor: kThemeColor),
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    left: kAppGapDimens,
                    right: 12,
                    bottom: 50,
                  ),
                  itemBuilder: (c, i) {
                    final BuddyReqListData item = _list[i];
                    return BuddyItemWidget(buddy: item.getBuddyModel());
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
            ),
          ],
        ),
      ),
    );
  }
}
