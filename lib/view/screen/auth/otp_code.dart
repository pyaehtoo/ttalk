import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/otp_request_res.dart';
import 'package:teatalk/network/res/otp_validation_res.dart';
import 'package:teatalk/service/db.dart';
import 'package:teatalk/util/constant.dart';
import 'package:teatalk/util/log.dart';
import 'package:teatalk/view/widget/auth_header.dart';
import 'package:teatalk/view/screen/auth/create_password.dart';
import 'package:teatalk/view/screen/auth/registration.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/text.dart';

import '../../../util/ao_lib.dart';
import '../../widget/link_btn.dart';
import '../../widget/primary_btn.dart';
import '../../theme/dimens.dart';

class OtpCodeScreen extends StatefulWidget {
  final OtpRequestRes otpRequest;
  final bool fromForgot;

  const OtpCodeScreen(
      {Key? key, required this.otpRequest, this.fromForgot = false})
      : super(key: key);

  @override
  State<OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState extends State<OtpCodeScreen> {
  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    DbService.instance.saveString(kLastOtpPref, DateTime.now().toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() async {
    AoLib.instance.dismissKeyboard();
    HapticFeedback.lightImpact();
    if (_otpCode.length != 6) {
      AoLib.instance.showSnack(context: context, message: "Please enter OTP!");
      return;
    }
    if (!widget.fromForgot) {
      AoLib.instance.showLoading(context);
      final OtpValidationRes? apiRes = await AppApi.instance.validateOtp(
        clientRef: widget.otpRequest.clientRef ?? '',
        otp: _otpCode,
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
        return;
      }
    }
    if (!mounted) return;
    final UserModel tmpUserModel = UserModel(
        widget.otpRequest.phone ?? '', '', '', '', null, null, '', null, null);
    final tmpStatus = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => widget.fromForgot
            ? CreatePasswordScreen(
                userModel: tmpUserModel,
                isFromForgot: true,
                otp: _otpCode,
              )
            : RegistrationScreen(otpRequest: widget.otpRequest),
      ),
    );
    if (!mounted || tmpStatus == null) return;
    Navigator.of(context).pop(tmpStatus);
  }

  void _resend() async {
    final DateTime now = DateTime.now();
    final String? lastSent = await DbService.instance.grabString(kLastOtpPref);
    if (!mounted) return;
    final DateTime? lastSentTime = DateTime.tryParse(lastSent ?? '');
    if (lastSentTime != null) {
      final DateTime shouldSent = lastSentTime.add(const Duration(minutes: 1));
      if (now.compareTo(shouldSent) < 0) {
        AoLib.instance.showSnack(
          context: context,
          message: "Please try again later!",
        );
        return;
      }
    }
    Navigator.of(context).pop("resend_otp");
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
            const AuthHeaderWidget(title: "OTP Code"),
            kSpacerV,
            const Text(
              "Enter the 6 digit codes which have been sent \nfrom SMS.",
              style: kTextStyle,
            ),
            kSpacerV,
            kSpacerV,
            kSpacerV,
            OtpTextField(
              numberOfFields: 6,
              borderColor: kThemeColor,
              cursorColor: kThemeColor,
              focusedBorderColor: kThemeColor,
              textStyle: kTextStyle,
              showFieldAsBox: true,
              fieldWidth: 45,
              autoFocus: true,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              onSubmit: (String verificationCode) {
                _otpCode = verificationCode;
                Log.d(verificationCode);
              },
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: "Haven't got the confirmation code yet? "),
                    linkButtonWidget("Resend Code", _resend, underline: false),
                  ],
                  style: kTextStyle.copyWith(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 50),
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
