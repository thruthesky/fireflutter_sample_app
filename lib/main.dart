import 'dart:async';

import 'package:fireflutter_sample_app/screens/admin/admin.screen.dart';
import 'package:fireflutter_sample_app/screens/admin/admin.category.screen.dart';
import 'package:fireflutter_sample_app/screens/forum/post.edit.screen.dart';
import 'package:fireflutter_sample_app/screens/forum/post.list.screen.dart';
import 'package:fireflutter_sample_app/screens/home/home.screen.dart';
import 'package:fireflutter_sample_app/screens/login/login.screen.dart';
import 'package:fireflutter_sample_app/screens/phone_auth/phone_auth.screen.dart';
import 'package:fireflutter_sample_app/screens/phone_auth/phone_auth_verification_code.screen.dart';
import 'package:fireflutter_sample_app/screens/profile/profile.screen.dart';
import 'package:fireflutter_sample_app/screens/register/register.screen.dart';
import 'package:fireflutter_sample_app/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import './global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ff.init(
    settings: {
      'app': {
        'verify-after-register': true,
        'verify-after-login': true,
        'force-verification': false,
        'block-non-verified-users-to-create': true,
      },
    },
  );
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    ff.translationsChange.listen((x) => setState(() => updateTranslations(x)));
    Timer(Duration(milliseconds: 200), () {
      // Get.toNamed(
      //   'forum-list',
      //   arguments: {'category': 'qna'},
      // );
      Get.toNamed('phone-auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'home',
      locale: ui.window.locale ?? Locale('ko'),
      fallbackLocale: Locale('ko'),
      translations: AppTranslations(),
      getPages: [
        GetPage(name: 'home', page: () => HomeScreen()),
        GetPage(name: 'register', page: () => RegisterScreen()),
        GetPage(name: 'login', page: () => LoginScreen()),
        GetPage(name: 'profile', page: () => ProfileScreen()),
        GetPage(name: 'admin', page: () => AdminScreen()),
        GetPage(name: 'admin-category', page: () => AdminCategoryScreen()),
        GetPage(name: 'forum-edit', page: () => ForumEditScreen()),
        GetPage(name: 'forum-list', page: () => ForumListScreen()),
        GetPage(name: 'phone-auth', page: () => PhoneAuthScreen()),
        GetPage(
            name: 'phone-auth-code-verification',
            page: () => PhoneAuthCodeVerificationScreen()),
      ],
    );
  }
}
