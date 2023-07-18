import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teatalk/provider/app.dart';
import 'package:teatalk/provider/buddy_world.dart';
import 'package:teatalk/provider/feed.dart';
import 'package:teatalk/provider/search.dart';
import 'package:teatalk/provider/user.dart';
import 'package:teatalk/service/db_keys.dart';
import 'package:teatalk/util/constant.dart';
import 'package:teatalk/view/screen/app/page/privacy_policy_page.dart';
import 'package:teatalk/view/screen/splash.dart';
import 'package:teatalk/view/theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox(BoxNameApp);
  // Setup picker to use Android photo picker
  final ImagePickerPlatform ipp = ImagePickerPlatform.instance;
  if (ipp is ImagePickerAndroid) ipp.useAndroidPhotoPicker = true;

  // SharedPreferences.setMockInitialValues({});
  // await SharedPreferences.getInstance();

  // End setup
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<FeedProvider>(create: (_) => FeedProvider()),
        ChangeNotifierProvider<BuddyWorldProvider>(
          create: (_) => BuddyWorldProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: kAppName,
        debugShowCheckedModeBanner: false,
        theme: kAppTheme,
        // home: PrivacyPolicyPage()
        home: const SplashScreen(),

        // home: RegistrationScreen(otpRequest: OtpRequestRes(true, '09757869868', 'hello', '')),
        );
  }
}
