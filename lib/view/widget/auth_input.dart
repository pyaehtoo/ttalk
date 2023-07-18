import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';
import 'package:teatalk/view/theme/dimens.dart';
import 'package:teatalk/view/theme/text.dart';

class AuthInputWidget extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool required;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Widget? prefix;
  final Widget? postfix;
  final Function(CountryCode)? onCountryChanged;
  final Function(String)? onSubmit;
  final CountryCode? countryCode;
  final bool readonly;
  final bool multiLines;

  const AuthInputWidget({
    Key? key,
    required this.label,
    this.required = false,
    this.placeholder = '',
    this.controller,
    this.focusNode,
    this.inputType,
    this.inputAction,
    this.prefix,
    this.postfix,
    this.countryCode,
    this.onCountryChanged,
    this.onSubmit,
    this.readonly = false,
    this.multiLines = false,
  }) : super(key: key);

  @override
  State<AuthInputWidget> createState() => _AuthInputWidgetState();
}

class _AuthInputWidgetState extends State<AuthInputWidget> {
  final _countryPicker = const FlCountryCodePicker(
    localize: false,
    title: SizedBox(height: 10),
    searchBarDecoration: InputDecoration(
      hintText: "Search Country",
      hintStyle: kTextStyle,
    ),
  );
  bool _isPasswordType = false;
  bool _isObscureText = false;
  bool _isPhoneNoType = false;
  late CountryCode _defaultCc;

  @override
  void initState() {
    super.initState();
    _isPasswordType =
        _isObscureText = (widget.inputType == TextInputType.visiblePassword);
    _isPhoneNoType = (widget.inputType == TextInputType.phone);
    _defaultCc = widget.countryCode ??
        const CountryCode(name: "Myanmar", code: "MM", dialCode: "+95");
  }

  void _pickCountry() async {
    final CountryCode? cc = await _countryPicker.showPicker(context: context);
    if (cc == null || !mounted) return;
    setState(() => _defaultCc = cc);
    final tmp = widget.onCountryChanged;
    if (tmp != null) tmp(_defaultCc);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kSpacerV,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: widget.label),
                if (widget.required)
                  TextSpan(
                    text: " *",
                    style:
                        kAuthLabelTextStyle.copyWith(color: kThemeAlertColor),
                  ),
              ],
              style: kAuthLabelTextStyle,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              if (_isPhoneNoType)
                InkWell(
                  onTap: _pickCountry,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kThemeBorderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 115,
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    margin: const EdgeInsets.only(right: 10),
                    height: 55,
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            _defaultCc.flagUri,
                            fit: BoxFit.cover,
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            package: _defaultCc.flagImagePackage,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            _defaultCc.dialCode,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 27),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kThemeBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  height: widget.multiLines ? null : 55,
                  child: Row(
                    children: [
                      widget.prefix ?? const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          readOnly: widget.readonly,
                          obscureText: _isObscureText,
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          textInputAction: widget.inputAction,
                          keyboardType: widget.inputType,
                          maxLines: widget.multiLines ? 4 : 1,
                          style: kTextStyle.copyWith(fontSize: 16),
                          onSubmitted: widget.onSubmit,
                          decoration: kInputDecoration.copyWith(
                            hintText: widget.placeholder,
                            hintStyle: kTextStyle.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                      widget.postfix ?? const SizedBox(),
                      _isPasswordType
                          ? SizedBox(
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscureText = !_isObscureText;
                                  });
                                },
                                highlightColor: Colors.transparent,
                                icon: Icon(
                                  _isObscureText
                                      ? CupertinoIcons.eye_slash_fill
                                      : CupertinoIcons.eye_fill,
                                ),
                              ),
                            )
                          : kSpacerH,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
