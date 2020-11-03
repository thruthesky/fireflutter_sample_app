import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          Row(
            children: [
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
            ],
          )
        ],
      ),
    );
  }
}
