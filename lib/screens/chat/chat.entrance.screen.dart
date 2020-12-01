import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatEntranceScreen extends StatefulWidget {
  ChatEntranceScreen({Key key}) : super(key: key);

  @override
  _ChatEntranceScreenState createState() => _ChatEntranceScreenState();
}

/// todo display sort by no of new messages.
/// todo sort by date of last message.
class _ChatEntranceScreenState extends State<ChatEntranceScreen> {
  ChatMyRoomList myRoomList;
  @override
  void initState() {
    super.initState();

    if (ff.notLoggedIn) return;

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
    if (myRoomList != null) myRoomList.leave();
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
      body: ff.notLoggedIn
          ? Center(child: Text('Please login'))
          : SingleChildScrollView(
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
                        DropdownButton<String>(
                            value: 'Sort by ...',
                            items: [
                              DropdownMenuItem(
                                value: 'Sort by ...',
                                child: Text('Sort by ...'),
                              ),
                              DropdownMenuItem(
                                value: 'newMessages',
                                child: Text('New Messages'),
                              ),
                              DropdownMenuItem(
                                value: 'createdAt',
                                child: Text('Last message date'),
                              ),
                            ],
                            onChanged: (value) {
                              print('chnaged: $value');
                              if (value == 'Sort by ...') return;

                              myRoomList.reset(order: value);
                            }),
                        // RaisedButton(
                        //     onPressed: () {}, child: Text('Sort by ...'))
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
                          // print(room);
                          return ListTile(
                            leading: senderPhoto(room),
                            title: Text((room['title'] ?? '')),
                            subtitle: Text("Users: ${room['users']?.length}, " +
                                "newMessages: ${room['newMessages']}, " +
                                "Moderator?: " +
                                (room['moderators'] != null &&
                                        room['moderators']
                                                .indexOf(ff.user.uid) >
                                            -1
                                    ? "Yes"
                                    : "No") +
                                ", " +
                                myRoomList.text(room)),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () => Get.toNamed('chat.room',
                                arguments: {'info': room}),
                          );
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
