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
        title: Text('FireFlutter'),
      ),
      body: Column(
        children: [
          Text('Routes and Screens'),
          Divider(),
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
                onPressed: () => Get.toNamed('logout'),
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
