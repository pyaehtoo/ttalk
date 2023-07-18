import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/transaction_vo.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/screen/app/post_detail.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/transation_history_background_widget.dart';

class ReceiveHistoryPage extends StatefulWidget {
  const ReceiveHistoryPage({Key? key}) : super(key: key);

  @override
  State<ReceiveHistoryPage> createState() => _ReceiveHistoryPageState();
}

class _ReceiveHistoryPageState extends State<ReceiveHistoryPage> {
  List<TransactionVO> transactionList = [];
  List<TransactionVO>? filteredTransactionList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await AppApi.instance
        .getStickerTransactionHistory(token: context.token!)
        .then((value) async {
      if (value != null) {
        setState(() {
          transactionList = value.data ?? [];
        });
      }
    });
  }

  void filterList(String imsAccount) async {
    setState(() {
      filteredTransactionList = transactionList
          .where((trasaction) => trasaction.accountTo == imsAccount)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch();
    userProvider.loadUser(context);
    final UserProfileModel? userProfile = userProvider.userProfile;
    String userImsId = userProfile?.imsAccountId ?? '';
    filterList(userImsId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sent History',
          style: kTextStyle.copyWith(
              fontFamily: 'Graphie', fontSize: 16, color: Colors.black),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: (filteredTransactionList == null)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (filteredTransactionList?.isEmpty ?? false)
                ? const Center(
                    child: Text('There is no transaction yet'),
                  )
                : SingleChildScrollView(
                    child: TransactionHistroyBackground(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Sent History (Sticker)',
                              style: kTextStyle.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 800,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    (filteredTransactionList?.length ?? 0) + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return const ReceivedHistoryTableTitleSectionView();
                                  }
                                  TransactionVO transactionVO =
                                      filteredTransactionList![index - 1];
                                  return ReceiveHistroyTransactionItem(
                                    transactionVO: transactionVO,
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

class ReceivedHistoryTableTitleSectionView extends StatelessWidget {
  const ReceivedHistoryTableTitleSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: kMarginMedium2,
        ),
        const ReceiveHistroyTransactionItem(transactionVO: null),
        const SizedBox(
          height: kMarginMedium2,
        ),
        Container(
          width: double.infinity,
          color: Colors.black45,
          height: 2,
        ),
        const SizedBox(
          height: kMarginMedium2,
        ),
      ],
    );
  }
}

class ReceiveHistroyTransactionItem extends StatelessWidget {
  final TransactionVO? transactionVO;
  const ReceiveHistroyTransactionItem({
    super.key,
    required this.transactionVO,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-DD hh:mm a');
    final DateTime date =
        DateTime.parse(transactionVO?.createdAt ?? DateTime.now().toString());
    final DateTime calculatedTimeForMMT = DateTime(
      date.year,
      date.month,
      date.day,
      date.hour + 6,
      date.minute + 30,
    );
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            transactionVO?.transactionId ?? 'Transaction ID',
            style: kTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            transactionVO?.stickerCode ?? 'Sticker Code',
            style: kTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            transactionVO?.fromUser?.userName ?? 'Received From',
            style: kTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 80,
          child: GestureDetector(
            onTap: () {
              if (transactionVO != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetailScreen(
                          action: 'sticker',
                          postId: transactionVO?.postId,
                        )));
              }
            },
            child: Text(
              (transactionVO != null) ? 'View Post' : 'Post ID',
              style: (transactionVO != null)
                  ? kTextStyle.copyWith(color: kThemeColor)
                  : kTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            transactionVO?.iceAmount?.toString() ?? 'Received ICE',
            style: kTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 180,
          child: Text(
            (transactionVO != null)
                ? dateFormat.format(calculatedTimeForMMT)
                : 'Received At',
            style: kTextStyle,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
