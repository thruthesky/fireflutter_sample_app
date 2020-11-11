import 'dart:async';

import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/screens/admin/admin.screen.dart';
import 'package:fireflutter_sample_app/screens/admin/admin.category.screen.dart';
import 'package:fireflutter_sample_app/screens/forum/post.edit.screen.dart';
import 'package:fireflutter_sample_app/screens/forum/post.list.screen.dart';
import 'package:fireflutter_sample_app/screens/home/home.screen.dart';
import 'package:fireflutter_sample_app/screens/login/login.screen.dart';
import 'package:fireflutter_sample_app/screens/phone_auth/phone_auth.screen.dart';
import 'package:fireflutter_sample_app/screens/phone_auth/phone_auth_verification_code.screen.dart';
import 'package:fireflutter_sample_app/screens/profile/profile.screen.dart';
import 'package:fireflutter_sample_app/screens/push-notification/push-notification.screen.dart';
import 'package:fireflutter_sample_app/screens/register/register.screen.dart';
import 'package:fireflutter_sample_app/screens/search/search.screen.dart';
import 'package:fireflutter_sample_app/screens/settings/settings.screen.dart';
import 'package:fireflutter_sample_app/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ff.init(
    settings: {
      'app': {
        'default-language': 'ko',
        'verify-after-register': true,
        'verify-after-login': true,
        'force-verification': false,
        'block-non-verified-users-to-create': false,
        'ALGOLIA_APP_ID': "W42X6RIXO5",
        'ALGOLIA_SEARCH_KEY': "710ce6c481caf890163ba0c24573130f",
        'ALGOLIA_INDEX_NAME': "Dev"
      },
    },
    translations: translations,
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
    ff.userChange.listen((x) {
      setState(() {
        Get.updateLocale(Locale(ff.userLanguage));
      });
    });
    Timer(Duration(milliseconds: 200), () {
      // Get.toNamed(
      //   'forum-list',
      //   arguments: {'category': 'qna'},
      // );
      // Get.toNamed('phone-auth');

      // () async {
      //   await ff.login(email: 'user@gmail.com', password: '12345a');
      //   print(ff.user.uid);
      //   print(ff.user.email);
      // }();
      // Get.toNamed('settings');
    });

    ff.notification.listen((x) {
      Map<dynamic, dynamic> notification = x['notification'];
      Map<dynamic, dynamic> data = x['data'];
      NotificationType type = x['type'];
      // print('NotificationType: $type');
      // print('notification: $notification');
      // print('data: $data');

      /// Ignore message from myself.
      if (data['senderUid'] == ff.user.uid) {
        return;
      }
      if (type == NotificationType.onMessage) {
        Get.snackbar(
          notification['title'].toString(),
          notification['body'].toString(),
          onTap: (_) {
            if (data != null && data['screen'] != null) {
              Get.toNamed(data['screen'], arguments: {'id': data['id'] ?? ''});
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'home',
      locale: Locale(ff.userLanguage),
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
        GetPage(name: 'push-notification', page: () => PushNotification()),
        GetPage(name: 'settings', page: () => SettingsScreen()),
        GetPage(name: 'search', page: () => SearchScreen()),
      ],
      routingCallback: (routing) {
        if (ff.loggedIn) {
          if (ff.user.phoneNumber.isNullOrBlank &&
              ff.appSetting('force-verification') ==
                  true) if (routing.current != 'home') {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Get.offNamed('phone-auth'));
          }
        }
      },
    );
  }
}
