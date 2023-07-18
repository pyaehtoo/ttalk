import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/view/screen/auth/sign_in.dart';
import 'package:teatalk/view/screen/intro.dart';

import '../../util/constant.dart';
import '../theme/widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final bool displayedIntro =
        (await DbService.instance.grabBool(kAppDisplayedIntro) ?? false);

    print('Display info =================> $displayedIntro');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            displayedIntro ? const SignInScreen() : const IntroScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kEmptyAppBar,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            child: SvgPicture.asset("assets/images/splash_logo.svg"),
          ),
        ),
      ),
    );
  }
}
