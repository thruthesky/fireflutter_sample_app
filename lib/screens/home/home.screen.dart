import 'package:fireflutter_sample_app/global_variables.dart';
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
      key: ValueKey('homeScreen'),
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
                  return Container();
                  // Text(
                  // 'UID: ${ff.user.uid}, Email: ${ff.user.email}, displayName: ${ff.user.displayName}, Phone: ${ff.user.phoneNumber}');
                } else {
                  return Text('You are not logged in.');
                }
              }),
          Divider(),
          Text('User Buttons'),
          Wrap(
            children: [
              RaisedButton(
                key: ValueKey('registerButton'),
                onPressed: () => Get.toNamed('register'),
                child: Text('Register'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('login'),
                child: Text('Login'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('profile'),
                child: Text('Profile'),
              ),
              RaisedButton(
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
