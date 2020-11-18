import 'dart:async';

import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatFrontScreen extends StatefulWidget {
  ChatFrontScreen({Key key}) : super(key: key);

  @override
  _ChatFrontScreenState createState() => _ChatFrontScreenState();
}

class _ChatFrontScreenState extends State<ChatFrontScreen> {
  ChatMyRoomList myRoomList;
  @override
  void initState() {
    super.initState();

    /// This may be moved to home screen.
    myRoomList = ChatMyRoomList(
        inject: ff,
        render: () {
          // print('no of my rooms: ' + roomList.rooms.length.toString());
          print(myRoomList.rooms);
          setState(() {});
        });
  }

  @override
  void dispose() {
    super.dispose();
    myRoomList.leave();
  }

  @override
  Widget build(BuildContext context) {
    /// TODO display user name and photo
    /// TODO display title
    /// TODO display last message
    /// TODO display no of new messages

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
                    return ListTile(
                      title: Text(myRoomList.rooms[i]['title'] ?? ''),
                      subtitle: Text(myRoomList.rooms[i]['id'] +
                          ': ' +
                          myRoomList.rooms[i]['text']),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () => Get.toNamed('chat.room',
                          arguments: {'info': myRoomList.rooms[i]}),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
