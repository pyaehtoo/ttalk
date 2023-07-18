import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/network/res/reset_pw_res.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/view/widget/auth_header.dart';

import '../../../network/api/app_layer.dart';
import '../../../network/res/register_res.dart';
import '../../../util/ao_lib.dart';
import '../../../util/constant.dart';
import '../../../util/log.dart';
import '../../widget/auth_input.dart';
import '../../widget/primary_btn.dart';
import '../../theme/dimens.dart';

class CreatePasswordScreen extends StatefulWidget {
  final UserModel userModel;
  final String otp;
  final bool isFromForgot;

  const CreatePasswordScreen({
    Key? key,
    required this.userModel,
    this.isFromForgot = false,
    this.otp = '',
  }) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _pwController = TextEditingController(),
      _pw2Controller = TextEditingController();
  final FocusNode _pwNode = FocusNode(), _pw2Node = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pwNode.dispose();
    _pw2Node.dispose();
    _pwController.dispose();
    _pw2Controller.dispose();
    super.dispose();
  }

  void _submit() async {
    AoLib.instance.dismissKeyboard();
    HapticFeedback.lightImpact();

    final String tmpPw = _pwController.text.trim();
    if (tmpPw.isEmpty) {
      _pwController.clear();
      _pwNode.requestFocus();
      return;
    }

    final String tmpPw2 = _pw2Controller.text.trim();
    if (tmpPw2.isEmpty) {
      _pw2Controller.clear();
      _pw2Node.requestFocus();
      return;
    }

    if (tmpPw != tmpPw2) {
      AoLib.instance.showSnack(
        context: context,
        message: "Your passwords are not match!",
      );
      return;
    }

    Log.d(tmpPw);
    final UserModel tmpUser = widget.userModel;
    tmpUser.password = tmpPw;
    tmpUser.confirmPassword = tmpPw2;

    AoLib.instance.showLoading(context);
    if (widget.isFromForgot) {
      final ResetPwRes? apiRes = await AppApi.instance.resetPassword(
        phone: tmpUser.phone,
        otp: widget.otp,
        password: tmpUser.password ?? '',
      );
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
        if (apiRes.msg == "Invalid OTP code.") {
          Navigator.of(context).pop();
        }
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop("success");
    } else {
      final RegisterRes? apiRes =
          await AppApi.instance.register(userModel: tmpUser);
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
      tmpUser.authToken = apiRes.data?.authToken;
      tmpUser.userId = apiRes.data?.userId;
      await DbService.instance
          .saveString(kAuthPref, jsonEncode(tmpUser.toJson()));
      if (!mounted) return;
      Navigator.of(context).pop("success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: kAppGapDimens),
          children: [
            const AuthHeaderWidget(title: "Create Password"),
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
              inputAction: TextInputAction.next,
              onSubmit: (_) => _pw2Node.requestFocus(),
            ),
            kSpacerV,
            AuthInputWidget(
              label: "Confirm Password",
              placeholder: "Enter your Password",
              controller: _pw2Controller,
              focusNode: _pw2Node,
              prefix: SizedBox(
                width: 50,
                child: SvgPicture.asset("assets/images/ic_lock.svg"),
              ),
              inputType: TextInputType.visiblePassword,
              inputAction: TextInputAction.done,
            ),
            const SizedBox(height: 80),
            PrimaryButtonWidget(
              text: 'Confirm',
              onPressed: _submit,
            ),
            kSpacerV,
            kSpacerV,
          ],
        ),
      ),
    );
  }
}
