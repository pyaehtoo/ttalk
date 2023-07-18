import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:teatalk/model/user.dart';
import 'package:teatalk/view/screen/auth/create_password.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/widget/auth_header.dart';
import 'package:teatalk/view/widget/date_picker.dart';

import '../../../network/res/otp_request_res.dart';
import '../../../util/ao_lib.dart';
import '../../theme/dimens.dart';
import '../../widget/auth_input.dart';
import '../../widget/primary_btn.dart';

class RegistrationScreen extends StatefulWidget {
  final OtpRequestRes otpRequest;

  const RegistrationScreen({Key? key, required this.otpRequest})
      : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController(),
      _lNameController = TextEditingController(),
      _uNameController = TextEditingController(),
      _birthController = TextEditingController();

  final FocusNode _fNameNode = FocusNode(),
      _lNameNode = FocusNode(),
      _uNameNode = FocusNode(),
      _birthNode = FocusNode();

  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _birthController.addListener(() {
      final String tmp = _birthController.text.trim();
      switch (tmp.length) {
        case 4:
        case 7:
          _birthController.text = "$tmp-";
          _birthNode.requestFocus();
          _birthController.selection = TextSelection.fromPosition(
            TextPosition(offset: _birthController.text.length),
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    _fNameNode.dispose();
    _lNameNode.dispose();
    _uNameNode.dispose();
    _birthNode.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _uNameController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  bool _validateDate() {
    final String tmp = _birthController.text.trim();
    late DateTime dateTime;
    if (tmp.length != 10) {
      AoLib.instance.showSnack(context: context, message: "Invalid date!");
      _birthController.clear();
      return false;
    }
    try {
      dateTime = _dateFormat.parse(tmp);
    } on Exception {
      AoLib.instance.showSnack(context: context, message: "Invalid date!");
      _birthController.clear();
      return false;
    }
    _birthController.text = _dateFormat.format(dateTime);
    return true;
  }

  void _submit() async {
    AoLib.instance.dismissKeyboard();
    HapticFeedback.lightImpact();

    final String tmpFirst = _fNameController.text.trim();
    final String tmpLast = _lNameController.text.trim();
    final String tmpUsername = _uNameController.text.trim();

    bool fullNameContainNumber = tmpFirst.contains(RegExp(r'[0-9]')) ||
        tmpLast.contains(RegExp(r'[0-9]'));

    bool usernameOnlyNumber = double.tryParse(tmpUsername) != null;

    if (fullNameContainNumber) {
      AoLib.instance
          .showErrorDialog('Full name should not contain number', context);
      _fNameController.clear();
      _fNameNode.requestFocus();
      _lNameController.clear();
      _lNameNode.requestFocus();
      return;
    }

    if (usernameOnlyNumber) {
      AoLib.instance
          .showErrorDialog("User name can't be only numbers", context);
      if (tmpFirst.contains(RegExp(r'[0-9]'))) {
        _fNameNode.requestFocus();
      }

      if (tmpLast.contains(RegExp(r'[0-9]'))) {
        _lNameNode.requestFocus();
      }
      return;
    }

    if (tmpFirst.isEmpty) {
      _fNameNode.requestFocus();
      return;
    }

    if (tmpLast.isEmpty) {
      _lNameController.clear();
      _lNameNode.requestFocus();
      return;
    }

    if (tmpUsername.isEmpty) {
      _uNameController.clear();
      _uNameNode.requestFocus();
      return;
    }
    final String tmpBirth = _birthController.text.trim();
    if (tmpBirth.isEmpty) {
      _birthController.clear();
      _birthNode.requestFocus();
      return;
    }
    if (!_validateDate()) return;

    final UserModel userModel = UserModel(
      widget.otpRequest.phone ?? '',
      tmpFirst,
      tmpLast,
      tmpUsername,
      null,
      null,
      tmpBirth,
      null,
      null,
    );
    // null values for next

    final tmpStatus = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePasswordScreen(userModel: userModel),
      ),
    );
    if (!mounted || tmpStatus == null) return;
    Navigator.of(context).pop(tmpStatus);
  }

  void _pickDate() async {
    // Should not allowed 13 years
    DateTime tmpDateTime =
        DateTime.now().subtract(const Duration(days: 365 * 13));
    final status = await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: DatePickerWidget(
          dateTime: tmpDateTime,
          onChanged: (_) => tmpDateTime = _,
        ),
      ),
    );
    if (!mounted || status == null) return;
    if (status == "set") {
      _birthController.text = _dateFormat.format(tmpDateTime);
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
            const AuthHeaderWidget(title: "Registration"),
            kSpacerV,
            AuthInputWidget(
              label: "First Name",
              placeholder: "Enter Your First Name",
              controller: _fNameController,
              focusNode: _fNameNode,
              required: true,
              inputType: TextInputType.name,
              inputAction: TextInputAction.next,
              onSubmit: (_) => _lNameNode.requestFocus(),
            ),
            kSpacerV,
            AuthInputWidget(
              label: "Last Name",
              placeholder: "Enter Your Last Name",
              controller: _lNameController,
              focusNode: _lNameNode,
              required: true,
              inputType: TextInputType.name,
              inputAction: TextInputAction.next,
              onSubmit: (_) => _uNameNode.requestFocus(),
            ),
            kSpacerV,
            AuthInputWidget(
              label: "Public username",
              placeholder: "Enter Public Username",
              controller: _uNameController,
              focusNode: _uNameNode,
              required: true,
              inputType: TextInputType.text,
              inputAction: TextInputAction.next,
              onSubmit: (_) => _birthNode.requestFocus(),
            ),
            kSpacerV,
            AuthInputWidget(
              label: "Date of Birth",
              placeholder: "YYYY-MM-DD",
              controller: _birthController,
              focusNode: _birthNode,
              required: true,
              inputType: TextInputType.datetime,
              inputAction: TextInputAction.done,
              readonly: true,
              postfix: InkWell(
                onTap: _pickDate,
                child: SizedBox(
                  width: 30,
                  child: SvgPicture.asset("assets/images/ic_calendar.svg"),
                ),
              ),
            ),
            const SizedBox(height: 60),
            PrimaryButtonWidget(
              text: 'Register',
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
