import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/util/ao_lib.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';
import 'package:teatalk/view/widget/app_btn.dart';
import 'package:teatalk/view/widget/auth_input.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({Key? key}) : super(key: key);

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool isLoading = false;

  Future<bool?> onTapUpdate() async {
    if (_newController.text != _confirmController.text) {
      AoLib.instance.showToast('Passwords did not matched');
    } else {
      if (_newController.text.length < 6) {
        AoLib.instance.showToast('Password needs to be at least 6 characters');
      }

      if (checkPassword(_newController.text)) {
        setState(() {
          isLoading = true;
        });
        return AppApi.instance
            .changeSticker(
                token: context.token!,
                oldPassword: _oldController.text,
                newPassword: _newController.text)
            .then((value) {
          if (value?.status ?? false) {
            AoLib.instance.showToast('Password update succes');
            return value?.status;
          } else {
            AoLib.instance.showToast(value?.msg ?? '');
            return false;
          }
        }).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        AoLib.instance.showToast(
            'Password needs to contain both numbers and alphabetic character');
      }
    }
  }

  bool checkPassword(String password) {
    bool containNumber = false;
    bool containCharacter = false;
    for (var i = 0; i < password.length; i++) {
      containNumber = password[i].contains(RegExp(r'[0-9]'));
      if (containNumber) {
        break;
      }
    }

    for (var i = 0; i < password.length; i++) {
      containCharacter = password[i].contains(RegExp(r'[a-zA-Z]'));
      if (containCharacter) {
        break;
      }
    }

    return (containCharacter && containNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Setting',
          style: kTextStyle.copyWith(
              fontFamily: 'Graphie', fontSize: 16, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kMarginMedium2),
        child: (isLoading)
            ? const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Password',
                      style: kTextStyle.copyWith(fontSize: 17),
                    ),
                    kSpacerV,
                    AuthInputWidget(
                      label: "Old Password",
                      placeholder: "Enter your current password",
                      controller: _oldController,
                      prefix: SizedBox(
                        width: 50,
                        child: SvgPicture.asset("assets/images/ic_lock.svg"),
                      ),
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                    ),
                    kSpacerV,
                    AuthInputWidget(
                      label: "New Password",
                      placeholder: "Enter your new password",
                      controller: _newController,
                      prefix: SizedBox(
                        width: 50,
                        child: SvgPicture.asset("assets/images/ic_lock.svg"),
                      ),
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                    ),
                    kSpacerV,
                    AuthInputWidget(
                      label: "Confirm Password",
                      placeholder: "Retype your Password",
                      controller: _confirmController,
                      prefix: SizedBox(
                        width: 50,
                        child: SvgPicture.asset("assets/images/ic_lock.svg"),
                      ),
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppButtonWidget(
                              text: 'Cancel',
                              background: kThemeColor.withOpacity(0.4),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        kSpacerH,
                        Expanded(
                          child: AppButtonWidget(
                              text: 'Update',
                              fontColor: Colors.white,
                              onPressed: () async {
                                await onTapUpdate().then((value) {
                                  if (value == true) {
                                    Navigator.pop(context);
                                  }
                                });
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
