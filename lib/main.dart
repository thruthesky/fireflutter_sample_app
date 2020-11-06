import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/screens/admin/admin.screen.dart';
import 'package:fireflutter_sample_app/screens/admin/admin.category.screen.dart';
import 'package:fireflutter_sample_app/screens/forum/forum.edit.dart';
import 'package:fireflutter_sample_app/screens/forum/forum.list.dart';
import 'package:fireflutter_sample_app/screens/home/home.screen.dart';
import 'package:fireflutter_sample_app/screens/login/login.screen.dart';
import 'package:fireflutter_sample_app/screens/profile/profile.screen.dart';
import 'package:fireflutter_sample_app/screens/push-notification/push-notification.screen.dart';
import 'package:fireflutter_sample_app/screens/register/register.screen.dart';
import 'package:fireflutter_sample_app/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import './global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ff.init(
    enableNotification: true,
    firebaseServerToken:
        'AAAAWrjrK94:APA91bGJuMd80xlpz1m8W61PxCS_2Ir_5y4mUcjPMUlNi-wGGaFoXQL9XiUTjBSv8fCSBBWa9-GTsuFNPWfrCF9TFOCmeJgzxtXfuS5EgH1NWEuEmlerbFAz-XIa2DYEpyQWkWwhFQJa',
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

    ff.notification.listen(
      (x) {
        Map<dynamic, dynamic> notification = x['notification'];
        Map<dynamic, dynamic> data = x['data'];
        NotificationType type = x['type'];
        print('NotificationType: $type');
        print('notification: $notification');
        print('data: $data');
        if (type == NotificationType.onMessage) {
          Get.snackbar(
            notification['title'].toString(),
            notification['body'].toString(),
            onTap: (_) {
              if (data != null && data['screen'] != null) {
                Get.toNamed(data['screen'],
                    arguments: {'id': data['id'] ?? ''});
              }
            },
            mainButton: (data != null && data['screen'] != null)
                ? FlatButton(
                    child: Text('Open'),
                    onPressed: () {
                      Get.toNamed(data['screen'],
                          arguments: {'id': data['id'] ?? ''});
                    },
                  )
                : Container(),
          );
        } else {
          /// App will come here when the user open the app by tapping a push notification on the system tray.
          if (data != null && data['screen'] != null) {
            Get.toNamed(data['screen'],
                arguments: {'id': data['id'] ?? '', 'data': data});
          }
        }
      },
    );
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
        GetPage(name: 'push-notification', page: () => PushNotification()),
      ],
    );
  }
}
