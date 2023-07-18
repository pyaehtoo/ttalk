import 'dart:convert';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/login_res.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/log.dart';
import 'package:teatalk/view/screen/app/app.dart';
import 'package:teatalk/view/screen/auth/forgot.dart';
import 'package:teatalk/view/screen/auth/sign_up.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/theme/widget.dart';
import 'package:teatalk/view/widget/link_btn.dart';
import 'package:teatalk/view/widget/logo.dart';
import 'package:teatalk/view/widget/primary_btn.dart';

import '../../../provider/feed.dart';
import '../../../service/db.dart';
import '../../../util/constant.dart';
import '../../widget/auth_input.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phController = TextEditingController(),
      _pwController = TextEditingController();
  final FocusNode _phNode = FocusNode(), _pwNode = FocusNode();
  late AnimationController _aniDropdownController,
      _aniLogoFadeOutController,
      _aniBgScaleOutController,
      _aniFadeOutController;
  final Tween<Offset> _tweenFallDown =
      Tween<Offset>(begin: const Offset(0, -.1), end: Offset.zero);
  final Tween<double> _tweenFadeOut = Tween<double>(begin: 1, end: 0);
  final Tween<double> _tweenFadeIn = Tween<double>(begin: 0.5, end: 1);
  final Tween<double> _tweenScale = Tween<double>(begin: 1, end: 7);
  bool _isLoggedIn = false;
  bool _finishedLoading = false;
  CountryCode _countryCode =
      const CountryCode(name: "Myanmar", code: "MM", dialCode: "+95");
  late FeedProvider _feedProvider;
  late AppProvider _appProvider;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _feedProvider = context.read();
    _appProvider = context.read();
    _aniDropdownController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _aniLogoFadeOutController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _aniBgScaleOutController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _aniFadeOutController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _startLoading();
    _appProvider.loadLocations();
    if (!mounted) return;
    _appProvider.loadReactions(context);
  }

  Future _checkLoggedIn() async {
    final String? tmpUserStr = await DbService.instance.grabString(kAuthPref);
    if (!mounted || tmpUserStr == null) return;
    try {
      final UserModel user = UserModel.fromJson(jsonDecode(tmpUserStr));
      print(user);
      Log.d(user.toJson());
      _isLoggedIn = true;
    } on Error catch (e) {
      Log.d(e);
      print('Error no user found');
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong!");
    }
  }

  void _startLoading({bool reset = false}) async {
    if (reset) {
      _aniDropdownController.reset();
      _aniLogoFadeOutController.reset();
      _aniBgScaleOutController.reset();
      _aniFadeOutController.reset();
      setState(() => _finishedLoading = false);
      _isLoggedIn = false;
    }
    // Fall down with fade out effect
    await _aniDropdownController.forward();
    // Delay
    await Future.delayed(const Duration(milliseconds: 350));
    // Fade out
    await _aniLogoFadeOutController.forward();
    // Scale in the background
    await _aniBgScaleOutController.forward();
    // Delay
    await Future.delayed(const Duration(milliseconds: 100));
    await _checkLoggedIn();
    if (!mounted) return;
    if (_isLoggedIn) {
      _gotoApp();
    } else {
      // Fade out the animation
      await _aniFadeOutController.forward();
      setState(() => _finishedLoading = true);
    }
  }

  @override
  void dispose() {
    _phNode.dispose();
    _pwNode.dispose();
    _phController.dispose();
    _pwController.dispose();
    _aniDropdownController.dispose();
    _aniLogoFadeOutController.dispose();
    _aniBgScaleOutController.dispose();
    _aniFadeOutController.dispose();
    super.dispose();
  }

  void _onCountryCodeChanged(CountryCode countryCode) {
    _countryCode = countryCode;
  }

  void _signIn() async {
    AoLib.instance.dismissKeyboard();
    HapticFeedback.lightImpact();

    String tmpPh = _phController.text.trim();
    if (tmpPh.isEmpty) {
      _phController.clear();
      _phNode.requestFocus();
      return;
    } else {
      if (tmpPh.length < 7) {
        _phController.clear();
        _phNode.requestFocus();
        return;
      }
      // tmpPh = tmpPh.startsWith('0') ? tmpPh.substring(1) : tmpPh;
    }

    final String tmpPw = _pwController.text.trim();
    if (tmpPw.isEmpty) {
      _pwController.clear();
      _pwNode.requestFocus();
      return;
    }

    // final String phNo = _countryCode.dialCode + tmpPh;
    final String phNo = tmpPh;
    AoLib.instance.showLoading(context);
    final LoginRes? apiRes =
        await AppApi.instance.login(phone: phNo, password: tmpPw);
    if (!mounted) return;
    Navigator.of(context).pop();

    if (apiRes == null) {
      AoLib.instance
          .showSnack(context: context, message: "Something went wrong!");
      return;
    }
    Log.d(apiRes.toJson());
    final status = apiRes.status ?? false;
    if (!status) {
      AoLib.instance.showSnack(
          context: context, message: apiRes.msg ?? "Something went wrong!");
      return;
    }
    final LoginResData? loginResData = apiRes.data;
    if (loginResData == null) return;
    final UserModel tmpUser = UserModel(
      loginResData.phone ?? '',
      loginResData.firstName ?? '',
      loginResData.lastName ?? '',
      loginResData.nickName ?? '',
      null,
      null,
      '',
      loginResData.accessToken,
      loginResData.userId,
    );
    await DbService.instance
        .saveString(kAuthPref, jsonEncode(tmpUser.toJson()));
    await DbService.instance
        .saveString(kAuthInfoPref, jsonEncode(loginResData.toJson()));
    _gotoApp();
  }

  void _gotoApp() async {
    final String? tmpUserStr = await DbService.instance.grabString(kAuthPref);
    if (!mounted || tmpUserStr == null) return;
    try {
      final UserModel user = UserModel.fromJson(jsonDecode(tmpUserStr));
      context.setUserProvider(user);
      _feedProvider.loadPosts(
          token: context.token, refresh: true, isMyArena: false);
      _feedProvider.loadPosts(token: context.token, refresh: true);
      await Future.delayed(const Duration(milliseconds: 200));
    } on Error catch (e) {
      Log.d(e);
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AppScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  void _signUp() async {
    final status = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
    if (!mounted) return;
    if (status == "success") _startLoading(reset: true);
  }

  void _forgotPw() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kEmptyAppBar,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: kAppGapDimens),
              children: [
                const SizedBox(height: 100),
                const LogoWidget(),
                const SizedBox(height: 40),
                Text(
                  "Sign In",
                  style: kTextStyle.copyWith(
                    fontSize: 30,
                  ),
                ),
                kSpacerV,
                kSpacerV,
                AuthInputWidget(
                  label: "Phone Number",
                  placeholder: "Enter Your Phone Number",
                  controller: _phController,
                  focusNode: _phNode,
                  inputType: TextInputType.phone,
                  inputAction: TextInputAction.next,
                  countryCode: _countryCode,
                  onCountryChanged: _onCountryCodeChanged,
                ),
                kSpacerV,
                AuthInputWidget(
                  label: "Password",
                  placeholder: "Enter your Password",
                  controller: _pwController,
                  focusNode: _pwNode,
                  prefix: SizedBox(
                    width: 50,
                    child: SvgPicture.asset("assets/images/ic_lock.svg"),
                  ),
                  inputType: TextInputType.visiblePassword,
                  inputAction: TextInputAction.done,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: linkButtonWidget("Forgot Password?", _forgotPw),
                  ),
                ),
                const SizedBox(height: 50),
                PrimaryButtonWidget(
                  text: 'Sign In',
                  onPressed: _signIn,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(text: "Don't have an account?"),
                        linkButtonWidget("Sign Up", _signUp),
                      ],
                      style: kTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                kSpacerV,
                kSpacerV,
              ],
            ),
          ),
          if (!_finishedLoading) ...[
            FadeTransition(
              opacity: _tweenFadeOut.animate(_aniFadeOutController),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: kThemeBgColor,
                  ),
                  ScaleTransition(
                    scale: _tweenScale.animate(_aniBgScaleOutController),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: const BoxDecoration(
                          color: kThemeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _tweenFadeOut.animate(_aniLogoFadeOutController),
                    child: FadeTransition(
                      opacity: _tweenFadeIn.animate(_aniDropdownController),
                      child: SlideTransition(
                        position:
                            _tweenFallDown.animate(_aniDropdownController),
                        child: const Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 220,
                            child: LogoWidget(width: 140, tag: 'disable'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
