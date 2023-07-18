// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/view/theme/color.dart';

import '../../network/res/reaction_res.dart';

class ReactionPopupWidget extends StatelessWidget {
  final Function(ReactionData) onReactionSelected;
  final Widget postWidget;

  const ReactionPopupWidget({
    super.key,
    required this.onReactionSelected,
    required this.postWidget,
  });

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = context.watch();
    final List<ReactionData> reactions = appProvider.reactions;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background container for the popup
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.black.withOpacity(0.85),
              // color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO
              postWidget,
              Container(
                width: double.infinity,
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: kThemeWhite,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...reactions
                        .map(
                          (_) => ReactionItemWidget(
                            reaction: _,
                            onSelected: () => onReactionSelected(_),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReactionItemWidget extends StatelessWidget {
  final ReactionData reaction;
  final Function() onSelected;

  const ReactionItemWidget({
    Key? key,
    required this.reaction,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.network(
            reaction.iconGif,
            width: 40.0,
            height: 40.0,
            errorBuilder: (context, error, stackTrace) => SvgPicture.network(
              reaction.iconSvg,
              width: 40.0,
              height: 40.0,
            ),
          )

          // CachedNetworkImage(
          //   imageUrl: reaction.iconGif,
          //   width: 40.0,
          //   height: 40.0,
          //   errorWidget: (c, _, __) {
          //     return SvgPicture.network(
          //       reaction.iconSvg,
          //       width: 40.0,
          //       height: 40.0,
          //     );
          //   },
          // ),
          ),
    );
  }
}
