import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatChattingScreen extends StatefulWidget {
  @override
  _ChatChattingScreenState createState() => _ChatChattingScreenState();
}

class _ChatChattingScreenState extends State<ChatChattingScreen> {
  Map<String, dynamic> roomInfo = {};
  @override
  void initState() {
    super.initState();
    init();
  }

  /// TODO listen the room info.
  init() async {
    if (Get.arguments['info'] != null) {
      Map<String, dynamic> myRoomInfo = Get.arguments['info'];
      roomInfo = await ff.chatGetRoomInfo(myRoomInfo['id']);
    } else {
      roomInfo = await ff.chatCreateRoom(users: [Get.arguments['uid']]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room ID: ${roomInfo['id']}'),
            Text('Users: ${roomInfo['users']}'),
          ],
        ),
      ),
    );
  }
}
