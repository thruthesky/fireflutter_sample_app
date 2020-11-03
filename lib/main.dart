import 'package:fireflutter_sample_app/screens/home/home.screen.dart';
import 'package:fireflutter_sample_app/screens/register/register.screen.dart';
import 'package:flutter/material.dart';
import 'package:fireflutter/fireflutter.dart';
import 'package:get/get.dart';

FireFlutter ff = FireFlutter();

void main() async {
  await ff.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'home',
      getPages: [
        GetPage(name: 'home', page: () => HomeScreen()),
        GetPage(name: 'home', page: () => RegisterScreen()),
      ],
    );
  }
}
