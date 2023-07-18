import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/default_res.dart';
import 'package:teatalk/network/res/user_profile_res.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/view/widget/auth_dropdown.dart';
import 'package:teatalk/view/widget/diary_profile_widget.dart';

import '../../../../util/ao_lib.dart';
import '../../../theme/color.dart';
import '../../../theme/dimens.dart';
import '../../../theme/text.dart';
import '../../../widget/auth_input.dart';
import '../../../widget/date_picker.dart';
import '../../../widget/primary_btn.dart';

class UpdateDiaryScreen extends StatefulWidget {
  final UserProfileModel userProfile;

  const UpdateDiaryScreen({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<UpdateDiaryScreen> createState() => _UpdateDiaryScreenState();
}

class _UpdateDiaryScreenState extends State<UpdateDiaryScreen> {
  late UserProfileModel _userProfile;
  final TextEditingController _fNameController = TextEditingController(),
      _lNameController = TextEditingController(),
      _uNameController = TextEditingController(),
      _emailController = TextEditingController(),
      _maritalController = TextEditingController(),
      _bioController = TextEditingController(),
      _birthController = TextEditingController();

  final FocusNode _fNameNode = FocusNode(),
      _lNameNode = FocusNode(),
      _uNameNode = FocusNode(),
      _emailNode = FocusNode(),
      _maritalNode = FocusNode(),
      _bioNode = FocusNode(),
      _birthNode = FocusNode();

  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
  String _selectedGender = "Other";
  XFile? pickedProfileImage;
  XFile? pickedCoverImage;

  final Map<String, String> maritalStatusOptions = {
    'single': 'Single',
    'married': 'Married',
    'Other': 'Other'
  };
  String _selectedMaritalStatus = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _userProfile = widget.userProfile;
    _fNameController.text = _userProfile.firstName ?? "";
    _lNameController.text = _userProfile.lastName ?? "";
    _uNameController.text = _userProfile.nickName ?? "";
    _emailController.text = _userProfile.email ?? "";
    final DateTime? birthdate = DateTime.tryParse(_userProfile.birthDate ?? "");
    if (birthdate != null) {
      _birthController.text = _dateFormat.format(birthdate);
    }
    _selectedGender = _userProfile.gender ?? "Other";
    _maritalController.text = _userProfile.maritalStatus ?? "";
    if (maritalStatusOptions.containsValue(_userProfile.maritalStatus ?? "")) {
      _selectedMaritalStatus =
          _userProfile.maritalStatus ?? maritalStatusOptions.values.first;
    } else {
      _selectedMaritalStatus = maritalStatusOptions.keys.first;
    }
    _bioController.text = _userProfile.bio ?? "";
  }

  @override
  void dispose() {
    _fNameNode.dispose();
    _lNameNode.dispose();
    _uNameNode.dispose();
    _emailNode.dispose();
    _birthNode.dispose();
    _bioNode.dispose();
    _maritalNode.dispose();
    _emailController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _uNameController.dispose();
    _birthController.dispose();
    _bioController.dispose();
    _maritalController.dispose();
    super.dispose();
  }

  void _pickMaritalStatus(String changeValue) {
    setState(() {
      _selectedMaritalStatus = changeValue;
    });
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

  void _pickedImage({required bool isGallery, required bool isProfile}) async {
    final ImagePicker imagePicker = ImagePicker();
    if (isProfile) {
      pickedProfileImage = await imagePicker.pickImage(
          source: isGallery ? ImageSource.gallery : ImageSource.camera);
      setState(() {});
    } else {
      pickedCoverImage = await imagePicker.pickImage(
          source: isGallery ? ImageSource.gallery : ImageSource.camera);
      setState(() {});
    }
  }

  void _saveChanges() async {
    AoLib.instance.dismissKeyboard();
    HapticFeedback.lightImpact();

    final String tmpFirst = _fNameController.text.trim();
    if (tmpFirst.isEmpty) {
      AoLib.instance.showToast('First Name is Required');
      _fNameController.clear();
      _fNameNode.requestFocus();
      return;
    }
    final String tmpLast = _lNameController.text.trim();
    if (tmpLast.isEmpty) {
      AoLib.instance.showToast('Last Name is Required');
      _lNameController.clear();
      _lNameNode.requestFocus();
      return;
    }
    final String tmpUsername = _uNameController.text.trim();
    if (tmpUsername.isEmpty) {
      AoLib.instance.showToast('Public Username is Required');
      _uNameController.clear();
      _uNameNode.requestFocus();
      return;
    }
    final String tmpEmail = _emailController.text.trim();
    if (tmpEmail.isEmpty) {
      AoLib.instance.showToast('Email is Required');
      _emailController.clear();
      _emailNode.requestFocus();
      return;
    }

    final String tmpBirthDate = _birthController.text;
    if (tmpBirthDate.isEmpty) {
      AoLib.instance.showToast('Date of Birth is Required');

      return;
    }
    // final String tmpMarital = _maritalController.text.trim();
    final String tmpBio = _bioController.text.trim();

    bool fullNameContainNumber = tmpFirst.contains(RegExp(r'[0-9]')) ||
        tmpLast.contains(RegExp(r'[0-9]'));

    bool usernameOnlyNumber = double.tryParse(tmpUsername) != null;

    if (fullNameContainNumber) {
      AoLib.instance
          .showErrorDialog('Full name should not contain number', context);
      if (tmpFirst.contains(RegExp(r'[0-9]'))) {
        _fNameNode.requestFocus();
      }

      if (tmpLast.contains(RegExp(r'[0-9]'))) {
        _lNameNode.requestFocus();
      }

      return;
    }

    if (usernameOnlyNumber) {
      AoLib.instance
          .showErrorDialog("User name can't be only numbers", context);
      _uNameNode.requestFocus();
      return;
    }

    // check email empty
    if (tmpEmail.isEmpty) {
      AoLib.instance.showErrorDialog('Email is Required', context);
      _emailNode.requestFocus();
      return;
    }

    // check email format
    const emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+";
    final regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(tmpEmail)) {
      AoLib.instance.showErrorDialog('Email Pattern is not corrected', context);
      _emailNode.requestFocus();
      return;
    }

    // soft copy
    final UserProfileModel tmpProfile =
        UserProfileModel.fromJson(_userProfile.toJson());
    tmpProfile
      ..firstName = tmpFirst
      ..lastName = tmpLast
      ..nickName = tmpUsername
      ..email = tmpEmail
      ..birthDate = tmpBirthDate
      ..maritalStatus = _selectedMaritalStatus
      ..bio = tmpBio
      ..gender = _selectedGender;

    AoLib.instance.showLoading(context);
    final UserProfileRes? tmp = await AppApi.instance
        .updateDiary(context: context, userProfile: tmpProfile)
        .then((value) async {
      String? token = context.token;
      if (pickedProfileImage != null) {
        final DefaultRes? tmpRes = await AppApi.instance
            .uploadProfileImageOrCover(
                token: token ?? '',
                image: pickedProfileImage!,
                isProfile: true);
        if (!(tmpRes?.status ?? false)) {
          AoLib.instance.showToast(tmpRes?.msg ?? '');
        }
      }
      if (pickedCoverImage != null) {
        final DefaultRes? tmpRes = await AppApi.instance
            .uploadProfileImageOrCover(
                token: token ?? '', image: pickedCoverImage!, isProfile: false);
        if (!(tmpRes?.status ?? false)) {
          AoLib.instance.showToast(tmpRes?.msg ?? '');
        }
      }
      return value;
    });
    if (!mounted) return;
    // Dismiss loading
    Navigator.of(context).pop();
    AoLib.instance.showSnack(
      context: context,
      message: tmp?.msg ?? "Something went wrong.",
    );
    final status = tmp?.status ?? false;
    if (status) Navigator.of(context).pop(tmpProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kThemeWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: SvgPicture.asset("assets/images/ic_back.svg"),
          tooltip: "Back",
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Edit Diary",
          style: kTextStyle.copyWith(fontSize: 17),
        ),
        centerTitle: true,
      ),
      backgroundColor: kThemeAppBgColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            DiaryProfileWidget(
              pickedCoverImage: pickedCoverImage,
              pickedProfileImage: pickedProfileImage,
              userProfile: _userProfile,
              isEdit: true,
              onProfileChanged: () async {
                await AoLib.instance.showPickImageDialog(context,
                    onTapCamera: () {
                  _pickedImage(isGallery: false, isProfile: true);
                }, onTapGallery: () {
                  _pickedImage(isGallery: true, isProfile: true);
                });
              },
              onCoverChanged: () async {
                await AoLib.instance.showPickImageDialog(context,
                    onTapCamera: () {
                  _pickedImage(isGallery: false, isProfile: false);
                }, onTapGallery: () {
                  _pickedImage(isGallery: true, isProfile: false);
                });
              },
            ),
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              primary: false,
              shrinkWrap: true,
              children: [
                kSpacerV,
                kSpacerV,
                Text(
                  "Personal Information",
                  style: kAuthLabelTextStyle.copyWith(fontSize: 18),
                ),
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
                  onSubmit: (_) => _emailNode.requestFocus(),
                ),
                kSpacerV,
                Row(
                  children: [
                    Expanded(
                      child: AuthInputWidget(
                        label: "Email",
                        placeholder: "Enter Mail",
                        controller: _emailController,
                        focusNode: _emailNode,
                        required: true,
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                      ),
                    ),
                    kSpacerH,
                    kSpacerH,
                    Expanded(
                      child: AuthInputWidget(
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
                            child: SvgPicture.asset(
                                "assets/images/ic_calendar.svg"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kSpacerV,
                // Start Gender
                kSpacerV,
                RichText(
                  text: const TextSpan(
                    children: [TextSpan(text: "Gender")],
                    style: kAuthLabelTextStyle,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  children: [
                    GenderItemWidget(
                      title: "Male",
                      activeValue: _selectedGender,
                      onSelected: (_) => setState(() => _selectedGender = _),
                      width: 80,
                    ),
                    GenderItemWidget(
                      title: "Female",
                      activeValue: _selectedGender,
                      onSelected: (_) => setState(() => _selectedGender = _),
                      width: 100,
                    ),
                    GenderItemWidget(
                      title: "Other",
                      activeValue: _selectedGender,
                      onSelected: (_) => setState(() => _selectedGender = _),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // End Gender
                // AuthInputWidget(
                //   label: "Marital Status",
                //   placeholder: "Enter Your Marital Status",
                //   controller: _maritalController,
                //   focusNode: _maritalNode,
                //   required: false,
                //   inputType: TextInputType.text,
                //   inputAction: TextInputAction.next,
                //   onSubmit: (_) => _bioNode.requestFocus(),
                // ),
                AuthDropdown(
                  label: "Marital Status",
                  isRequired: false,
                  itemList: maritalStatusOptions,
                  initialValue: _selectedMaritalStatus,
                  onChanged: (value) {
                    _pickMaritalStatus(value);
                  },
                ),
                kSpacerV,
                AuthInputWidget(
                  label: "Bio",
                  placeholder: "Enter Your Bio",
                  controller: _bioController,
                  focusNode: _bioNode,
                  required: false,
                  multiLines: true,
                  inputType: TextInputType.multiline,
                  inputAction: TextInputAction.newline,
                ),
                kSpacerV,
                const SizedBox(height: 40),
                PrimaryButtonWidget(
                  text: 'Save Changes',
                  fontColor: Colors.white,
                  onPressed: _saveChanges,
                ),
                kSpacerV,
                kSpacerV,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GenderItemWidget extends StatelessWidget {
  final String title;
  final String activeValue;
  final Function(String) onSelected;
  final double width;

  const GenderItemWidget({
    Key? key,
    required this.title,
    required this.onSelected,
    required this.activeValue,
    this.width = 90,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = (title == activeValue) ? 'active' : 'inactive';
    return InkWell(
      onTap: () => onSelected(title),
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: width,
        height: 45,
        margin: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: SvgPicture.asset("assets/images/ic_radio_$status.svg"),
            ),
            kSpacerH,
            Expanded(
              child: Text(
                title,
                style: kTextStyle.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
