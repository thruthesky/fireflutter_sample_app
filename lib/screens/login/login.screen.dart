import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../global_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginScreen'),
      ),
      body: Column(
        children: [
          Text('Social Login'),
          Divider(),
          RaisedButton(
            child: Text('Google Sign-in'),
            onPressed: () async {
              try {
                await ff.signInWithGoogle();
                Get.toNamed('home');
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
          ),
          RaisedButton(
            child: Text('Facebook Sign-in'),
            onPressed: () async {
              try {
                await ff.signInWithFacebook();
                Get.toNamed('home');
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
          ),
          if (GetPlatform.isIOS)
            SignInWithAppleButton(
              onPressed: () async {
                try {
                  await ff.signInWithApple();
                  Get.toNamed('home');
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
            )
        ],
      ),
    );
  }
}
