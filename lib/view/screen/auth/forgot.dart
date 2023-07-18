import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/view/widget/auth_header.dart';
import 'package:teatalk/view/screen/auth/otp_code.dart';

import '../../../network/api/app_layer.dart';
import '../../../network/res/otp_request_res.dart';
import '../../../util/ao_lib.dart';
import '../../../util/log.dart';
import '../../widget/auth_input.dart';
import '../../widget/primary_btn.dart';
import '../../theme/dimens.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phController = TextEditingController();
  final FocusNode _phNode = FocusNode();

  CountryCode _countryCode =
      const CountryCode(name: "Myanmar", code: "MM", dialCode: "+95");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phNode.dispose();
    _phController.dispose();
    super.dispose();
  }

  void _onCountryCodeChanged(CountryCode countryCode) {
    _countryCode = countryCode;
  }

  void _sendOTP() async {
    AoLib.instance.dismissKeyboard();
    HapticFeedback.lightImpact();

    String tmpPh = _phController.text.trim();
    if (tmpPh.isEmpty) {
      _phController.clear();
      _phNode.requestFocus();
      return;
    } else {
      //  tmpPh = tmpPh.startsWith('0') ? tmpPh.substring(1) : tmpPh;
    }
    //   final String phNo = _countryCode.dialCode + tmpPh;
    final String phNo = tmpPh;
    Log.d(phNo);
    _requestOtp(phNo);
  }

  void _requestOtp(String phone) async {
    AoLib.instance.showLoading(context);
    final OtpRequestRes? apiRes =
        await AppApi.instance.requestForgetPasswordOtp(phone: phone);
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
      AoLib.instance
          .showSnack(context: context, message: apiRes.message ?? "Failed to send OTP!");
      return;
    }
    AoLib.instance.showSnack(context: context, message: "OTP has been sent!");
    _validateOTP(apiRes);
  }

  void _validateOTP(OtpRequestRes otpRequestRes) async {
    final status = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            OtpCodeScreen(otpRequest: otpRequestRes, fromForgot: true),
      ),
    );
    if (!mounted || status == null || status != "success") {
      if (status == "resend_otp") {
        // Just delay for animation
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        _requestOtp(otpRequestRes.phone ?? '');
      }
      return;
    }
    AoLib.instance.showSnack(context: context, message: "Success!");
    Navigator.of(context).pop("success");
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
            const AuthHeaderWidget(title: "Forgot Password"),
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
            const SizedBox(height: 80),
            PrimaryButtonWidget(
              text: 'Send OTP',
              onPressed: _sendOTP,
            ),
            kSpacerV,
            kSpacerV,
          ],
        ),
      ),
    );
  }
}
