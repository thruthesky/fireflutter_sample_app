import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      'Email: ${ff.user.email}, displayName: ${ff.user.displayName}');
                } else {
                  return Text('You are not logged in.');
                }
              }),
          Divider(),
          Text('User Buttons'),
          Row(
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
                onPressed: ff.logout,
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
