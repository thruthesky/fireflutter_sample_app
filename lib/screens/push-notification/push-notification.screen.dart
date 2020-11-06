import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification'.tr),
      ),
      body: Column(
        children: [
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
          Text('Device Token: '),
          Text(ff.firebaseMessagingToken),
          RaisedButton(
            onPressed: () async {
              ff.sendNotification(
                'Sample push notification to topic',
                'This is the content of push to topic',
                screen: 'home',
                topic: ff.allTopic,
                test: true,
              );
            },
            child: Text('Send notification to topic'),
          ),
          RaisedButton(
            onPressed: () async {
              ff.sendNotification(
                'Sample push notification to own token',
                'This is the content of push to token',
                screen: 'home',
                token: ff.firebaseMessagingToken,
                test: true,
              );
            },
            child: Text('Send notification to own token'),
          ),
          RaisedButton(
            onPressed: () async {
              ff.sendNotification(
                'Sample push notification to own tokens',
                'This is the content of push to tokens',
                screen: 'home',
                tokens: [ff.firebaseMessagingToken],
                test: true,
              );
            },
            child: Text('Send notification to own tokens'),
          ),
        ],
      ),
    );
  }
}
