import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController favoriteColorController = TextEditingController();

  bool loading = false;
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
          TextFormField(
            controller: displayNameController,
            decoration: InputDecoration(hintText: 'displayName'),
          ),
          TextFormField(
            controller: favoriteColorController,
            decoration:
                InputDecoration(hintText: 'What is your favorite color?'),
          ),
          RaisedButton(
            onPressed: () async {
              setState(() => loading = true);
              try {
                await ff.register({
                  'email': emailController.text,
                  'password': passwordController.text,
                  'displayName': displayNameController.text,
                  'favoriteColor': favoriteColorController.text
                }, public: {
                  "notifyPost": true,
                  "notifyComment": true,
                });
                setState(() => loading = false);
                if (ff.appSetting('verify-after-register') == true) {
                  Get.toNamed('phone-verification');
                } else {
                  Get.toNamed('home');
                }
              } catch (e) {
                setState(() => loading = false);
                Get.snackbar('Error', e.toString());
              }
            },
            child: loading ? CircularProgressIndicator() : Text('Register'),
          ),
        ],
      ),
    );
  }
}
