import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomSettingScreen extends StatefulWidget {
  @override
  _ChatRoomSettingScreenState createState() => _ChatRoomSettingScreenState();
}

class _ChatRoomSettingScreenState extends State<ChatRoomSettingScreen> {
  Map<String, dynamic> roomInfo;
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ff.chatGetRoomInfo(Get.arguments['roomId']).then((value) {
      roomInfo = value;
      titleController.text = roomInfo['title'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room Setting'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Text('Title'),
          TextFormField(
            controller: titleController,
          ),
          RaisedButton(
            onPressed: () async {
              try {
                await ff.chatUpdateRoom(roomInfo['id'],
                    title: titleController.text);
                Get.snackbar('Update', 'Chat room setting has been updated.');
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            child: Text('Submit'),
          )
        ]),
      ),
    );
  }
}
