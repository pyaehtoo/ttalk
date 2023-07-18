// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/reaction_res.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/widget/avatar.dart';

import '../../../network/res/post_reacts_res.dart';
import '../../theme/color.dart';
import '../../theme/text.dart';

class PostReactScreen extends StatefulWidget {
  final int postId;

  const PostReactScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostReactScreen> createState() => _PostReactScreenState();
}

class _PostReactScreenState extends State<PostReactScreen> {
  final List<PostReactData> _reactList = [];
  late AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
    _appProvider = context.read();
    _loadReact();
  }

  Future<void> _loadReact() async {
    _reactList.clear();
    final PostReactsRes? postReactsRes = await AppApi.instance
        .reactsOfPost(context: context, postId: widget.postId);
    if (!mounted) return;
    if (postReactsRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong");
      return;
    }
    setState(() {
      _reactList.addAll(postReactsRes.data ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .4,
        backgroundColor: kThemeWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          "People who reacted this post",
          style: kTextStyle.copyWith(fontSize: 17),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: kThemeBgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadReact,
          child: ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: _reactList.length,
            separatorBuilder: (c, i) => const Divider(height: 25),
            itemBuilder: (c, i) {
              final PostReactData react = _reactList[i];
              final ReactionData? reactionData =
                  _appProvider.findReaction(react.react);
              final String? gif = reactionData?.iconGif;
              return Row(
                children: [
                  AvatarWidget(profileUrl: react.profileImageUrl, size: 60),
                  kSpacerH,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${react.nickName}",
                                style: kTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " : ${reactionData?.name} the post.",
                                style: kTextStyle.copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        if (gif != null) ...[
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 24,
                            height: 24,
                            // child: CachedNetworkImage(
                            //   imageUrl: gif,
                            //   fit: BoxFit.contain,
                            // ),

                             child: Image.network(
                               gif,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
