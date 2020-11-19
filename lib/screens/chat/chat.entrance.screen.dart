import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatEntranceScreen extends StatefulWidget {
  ChatEntranceScreen({Key key}) : super(key: key);

  @override
  _ChatEntranceScreenState createState() => _ChatEntranceScreenState();
}

class _ChatEntranceScreenState extends State<ChatEntranceScreen> {
  ChatMyRoomList myRoomList;
  @override
  void initState() {
    super.initState();

    /// This may be moved to home screen.
    myRoomList = ChatMyRoomList(
        inject: ff,
        render: () {
          setState(() {});
        });
  }

  @override
  void dispose() {
    super.dispose();
    myRoomList.leave();
  }

  senderPhoto(Map<String, dynamic> roomInfo) {
    if (roomInfo == null) return SizedBox.shrink();
    if (roomInfo['senderPhotoURL'] == null) return SizedBox.shrink();
    return Image.network(roomInfo['senderPhotoURL']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RaisedButton(
                    onPressed: () => Get.toNamed('chat.find_friend'),
                    child: Text('Find Friends'),
                  ),
                ],
              ),
              Divider(),
              Text('My chat room list'),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: myRoomList.rooms.length,
                  itemBuilder: (_, i) {
                    Map<String, dynamic> room = myRoomList.rooms[i];
                    return ListTile(
                      leading: senderPhoto(room),
                      title: Text(
                          (room['title'] ?? '') + " (${room['newMessages']})"),
                      subtitle: Text(room['id'] +
                          ': ' +

                          /// todo make a method, `chat.text()` to get text of the message.
                          room['text']),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () =>
                          Get.toNamed('chat.room', arguments: {'info': room}),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
