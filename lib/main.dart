import 'package:fireflutter_sample_app/screens/home/home.screen.dart';
import 'package:fireflutter_sample_app/screens/login/login.screen.dart';
import 'package:fireflutter_sample_app/screens/profile/profile.screen.dart';
import 'package:fireflutter_sample_app/screens/register/register.screen.dart';
import 'package:fireflutter_sample_app/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import './global_variables.dart';

void main() async {
  await ff.init();
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
      ],
    );
  }
}
