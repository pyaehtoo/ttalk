import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/widget/confirm_dialog.dart';
import 'package:teatalk/view/widget/icon_and_text_button.dart';
import 'package:teatalk/view/widget/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class AoLib {
  static AoLib? _instance;

  static AoLib get instance => _instance ??= AoLib();

  AoLib();

  void showSnack({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    final ScaffoldMessengerState smState = ScaffoldMessenger.of(context);
    smState.clearSnackBars();
    smState.showSnackBar(SnackBar(content: Text(message), duration: duration));
  }

  Future showLoading(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) => const LoadingWidget(),
    );
  }

  Future<void> openUrl(String url) async {
    print('Url ====> $url');
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      print('Can Launch');
      launchUrl(uri, mode: LaunchMode.inAppWebView, webOnlyWindowName: '_self')
          .then(((value) {
        if (value == false) {
          Fluttertoast.showToast(
              msg: 'Sorry, This Link Cannot Open. Something went wrong',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      }));
    } else {
      Fluttertoast.showToast(
          msg: 'Sorry, This Link Cannot Open. Something went wrong',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  Future<void> showToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Future showConfirmDialog(BuildContext context,
      {bool dismissible = true,
      String title = 'Confirm',
      required String content,
      String cancel = 'Cancel',
      String action = 'Okay',
      Function()? onCancelled,
      Function()? onActionPressed,
      CrossAxisAlignment crossAxisAlignment =
          CrossAxisAlignment.center}) async {
    return showDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierColor: Colors.black45,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConfirmDialogWidget(
            title: title,
            content: content,
            cancel: cancel,
            action: action,
            onCancelled: onCancelled,
            onAction: onActionPressed,
            crossAxisAlignment: crossAxisAlignment,
          ),
        ),
      ),
    );
  }

  String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  Future<void> showPickImageDialog(BuildContext context,
      {required Function onTapCamera, required Function onTapGallery}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          child: Container(
            color: Colors.transparent,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconAndTextButton(
                    iconData: Icons.camera,
                    text: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      onTapCamera();
                    }),
                const SizedBox(
                  width: 16,
                ),
                IconAndTextButton(
                    iconData: Icons.folder_open,
                    text: 'Gallery',
                    onTap: () async {
                      Navigator.pop(context);
                      onTapGallery();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorDialog(String errorMsg, BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(errorMsg),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kThemePrimaryColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text('Okay'),
                ),
              )
            ],
          );
        });
  }

  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  String htmlCharCodeToEmoji(String? input) {
    if (input == null) return '';
    final RegExp exp = RegExp(r'&#(\d+);');
    return input.replaceAllMapped(exp, (match) {
      int code = int.parse(match.group(1)!);
      return String.fromCharCode(code);
    });
  }

  String emojiToHtml(String? input) {
    if (input == null) return '';
    final StringBuffer output = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final int code = input.codeUnitAt(i);
      if (code > 0xFFFF) {
        output.write('&#${code.toRadixString(10)};');
      } else if (code >= 0xD800 && code <= 0xDBFF && i < input.length - 1) {
        final int nextCode = input.codeUnitAt(i + 1);
        if (nextCode >= 0xDC00 && nextCode <= 0xDFFF) {
          final int combinedCode =
              ((code - 0xD800) << 10) + (nextCode - 0xDC00) + 0x10000;
          output.write('&#${combinedCode.toRadixString(10)};');
          i++; // skip over the next code unit
        } else {
          output.write(input[i]);
        }
      } else {
        output.write(input[i]);
      }
    }
    return output.toString();
  }

  int calculateAge(DateTime birthDate) {
    int age = 0;
    DateTime today = DateTime.now();
    age = today.year - birthDate.year;

    if (today.month > birthDate.month) {
      age--;
    } else if (today.month == birthDate.month) {
      if (today.day > birthDate.day) {
        age--;
      }
    }

    return age;
  }
}
