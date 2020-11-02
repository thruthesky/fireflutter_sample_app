import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScrreen extends StatefulWidget {
  @override
  _RegisterScrreenState createState() => _RegisterScrreenState();
}

class _RegisterScrreenState extends State<RegisterScrreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Email Address'),
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          RaisedButton(
            onPressed: () async {
              // User
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}
