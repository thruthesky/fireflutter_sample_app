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
    ff.login(email: 'user@gmail.com', password: '12345a');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Email: ${ff.user.email}, displayName: ${ff.user.displayName}, Phone: ${ff.user.phoneNumber}');
                } else {
                  return Text('You are not logged in.');
                }
              }),
          Divider(),
          Text('User Buttons'),
          Wrap(
            children: [
              RaisedButton(
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
                onPressed: () async {
                  try {
                    await ff.logout();
                    print('logged out');
                  } catch (e) {
                    print(e);
                    Get.snackbar('Error', e.toString());
                  }
                },
                child: Text('Logout'),
              ),
              RaisedButton(
                onPressed: () => Get.toNamed('phone-auth'),
                child: Text('Phone Verificatoin'),
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
          Row(
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
            ],
          ),
        ],
      ),
    );
  }
}
