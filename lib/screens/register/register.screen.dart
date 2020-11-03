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
                User user = await ff.register({
                  'email': emailController.text,
                  'password': passwordController.text,
                  'displayName': displayNameController.text,
                  'favoriteColor': favoriteColorController.text
                }, meta: {
                  "public": {
                    "notifyPost": true,
                    "notifyComment": true,
                  }
                });
                setState(() => loading = false);
                await Get.defaultDialog(
                  middleText: 'Welcome ' + user.displayName,
                  textConfirm: 'Ok',
                  confirmTextColor: Colors.white,
                  onConfirm: () => Get.back(),
                );
                Get.toNamed('home');
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
