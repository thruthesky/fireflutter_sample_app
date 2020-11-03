import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfileScreen'),
      ),
      body: Text('ProfileScreen'),
    );
  }
}
