import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/theme/widget.dart';

import '../../util/constant.dart';
import '../widget/logo.dart';
import '../theme/dimens.dart';
import 'auth/sign_in.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController(initialPage: 0);
  final List<String> _heroText = [
    "Share your ideas Venture your Life.",
    "Surprise your Buddies with Stickers!",
    "Spread your network with your Buddies.",
  ];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _gotoSignIn() async {
    HapticFeedback.lightImpact();
    await DbService.instance.saveBool(kAppDisplayedIntro, true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignInScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kEmptyAppBar,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(height: 100),
                const LogoWidget(),
                const SizedBox(height: 40),
                const SizedBox(height: 320),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kAppGapDimens),
                  child: Text(
                    _heroText[_index],
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(fontSize: 17),
                  ),
                ),
                kSpacerV,
                kSpacerV,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _heroText.map((e) {
                    if (e == _heroText[_index]) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 6, right: 6, top: 6),
                        child: SvgPicture.asset(
                            "assets/images/ic_active_hero.svg"),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        onTap: () {
                          _controller.animateToPage(
                            _heroText.indexOf(e),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear,
                          );
                        },
                        child: SvgPicture.asset(
                            "assets/images/ic_inactive_hero.svg"),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            PageView.builder(
              controller: _controller,
              itemCount: _heroText.length,
              onPageChanged: (_) => setState(() => _index = _),
              itemBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 240),
                    child: SizedBox(
                      width: 350,
                      height: 300,
                      child: SvgPicture.asset("assets/images/hero_$index.svg"),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: InkWell(
                  onTap: () {
                    if (_index == _heroText.length - 1) {
                      _gotoSignIn();
                      return;
                    }
                    _controller.animateToPage(
                      _index + 1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  },
                  child: Text(
                    "NEXT",
                    style: kTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
