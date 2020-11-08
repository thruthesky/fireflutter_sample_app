import 'package:fireflutter_sample_app/keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../global_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
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
            ),
          SizedBox(
            height: 64,
          ),
          Text('Eamil & Password Login'),
          Divider(),
          TextFormField(
            key: ValueKey(Keys.lfEmail),
            controller: emailController,
            decoration: InputDecoration(hintText: 'Email address'),
          ),
          TextFormField(
            key: ValueKey(Keys.lfPassword),
            controller: passwordController,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          RaisedButton(
            key: ValueKey(Keys.lfSubmitButton),
            onPressed: () async {
              setState(() => loading = true);
              try {
                await ff.login(
                  email: emailController.text,
                  password: passwordController.text,
                );
                if (ff.user.phoneNumber.isNullOrBlank &&
                    ff.appSetting('verify-after-login') == true) {
                  Get.toNamed('phone-auth');
                } else {
                  Get.toNamed('home');
                }
              } catch (e) {
                Get.snackbar('Error', e.toString());
              } finally {
                setState(() => loading = false);
              }
            },
            child: loading ? CircularProgressIndicator() : Text('Login'),
          ),
        ],
      ),
    );
  }
}
