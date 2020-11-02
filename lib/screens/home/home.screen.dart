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
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () => Get.toNamed('register'),
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
