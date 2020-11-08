import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:fireflutter_sample_app/keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(Keys.homeScreen),
      appBar: AppBar(
        title: Text('app-name'.tr),
      ),
      body: Column(
        children: [
          Text('User Information'),
          StreamBuilder(
              stream: ff.userChange,
              builder: (context, snapshot) {
                if (ff.userIsLoggedIn) {
                  return Text(
                    'Email: ${ff.user.email}, Color: ${ff.userData['favoriteColor']}, UID: ${ff.user.uid}, displayName: ${ff.user.displayName}, Phone: ${ff.user.phoneNumber},',
                    key: ValueKey(Keys.hInfo),
                  );
                } else {
                  return Text(
                    'Please login',
                    key: ValueKey(Keys.hPleaseLogin),
                  );
                }
              }),
          Divider(),
          Text('User Buttons'),
          Wrap(
            children: [
              RaisedButton(
                key: ValueKey(Keys.rButton),
                onPressed: () => Get.toNamed('register'),
                child: Text('Register'),
              ),
              RaisedButton(
                key: ValueKey(Keys.hLoginButton),
                onPressed: () => Get.toNamed('login'),
                child: Text('Login'),
              ),
              RaisedButton(
                key: ValueKey(Keys.hProfileButotn),
                onPressed: () => Get.toNamed('profile'),
                child: Text('Profile'),
              ),
              RaisedButton(
                key: ValueKey(Keys.hLogoutButton),
                onPressed: ff.logout,
                child: Text('Logout'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('phone-auth'),
                child: Text('Phone Verificatoin'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('settings'),
                child: Text('Settings'),
              ),
              DropdownButton<String>(
                value: ff.userLanguage,
                items: [
                  DropdownMenuItem(value: 'ko', child: Text('Korean')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (String value) {
                  ff.updateProfile({'language': value});
                },
              ),
            ],
          ),
          if (ff.isAdmin) ...[
            Divider(),
            RaisedButton(
              onPressed: () => Get.toNamed('admin'),
              child: Text('Admin Screen'),
            ),
          ],
          Divider(),
          Wrap(
            children: [
              RaisedButton(
                onPressed: () =>
                    Get.toNamed('forum-edit', arguments: {'category': 'qna'}),
                child: Text('Create a Post'),
              ),
              RaisedButton(
                onPressed: () =>
                    Get.toNamed('forum-list', arguments: {'category': 'qna'}),
                child: Text('QnA Forum'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('forum-list',
                    arguments: {'category': 'discussion'}),
                child: Text('Discussion Forum'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('search'),
                child: Text('Search'),
              ),
            ],
          ),
          Divider(),
          RaisedButton(
            onPressed: () => Get.toNamed('push-notification'),
            child: Text('Push Notification'),
          ),
        ],
      ),
    );
  }
}
