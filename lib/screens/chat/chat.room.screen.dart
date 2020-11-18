import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  Map<String, dynamic> roomInfo = {};
  final textController = TextEditingController();
  ChatRoom chat;
  final scrollController = ScrollController();
  bool firstFetch = false;

  bool get atBottom =>
      scrollController.offset >
      (scrollController.position.maxScrollExtent - 640);

  bool get atTop {
    return scrollController.position.pixels < 200;
  }

  bool get scrollUp {
    return scrollController.position.userScrollDirection ==
        ScrollDirection.forward;
  }

  bool get scrollDown {
    return scrollController.position.userScrollDirection ==
        ScrollDirection.reverse;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  /// TODO listen the room info and maintain the latest room info for updating user list and others.
  init() async {
    if (Get.arguments['info'] != null) {
      Map<String, dynamic> myRoomInfo = Get.arguments['info'];
      roomInfo = await ff.chatGetRoomInfo(myRoomInfo['id']);
    } else {
      roomInfo = await ff.chatCreateRoom(users: [Get.arguments['uid']]);
    }
    setState(() {});

    chat = ChatRoom(
        inject: ff,
        roomId: roomInfo['id'],
        render: () {
          setState(() {});

          if (!firstFetch) {
            scrollToBottomOnLoad();
          } else if (atBottom) {
            scrollToBottom();
          }
        });

    scrollController.addListener(() {
      if (scrollUp && atTop) {
        chat.fetchMessages();
      }
    });
  }

  String dateTime(dynamic dt) {
    /// Server timestamp fires the event twice.
    if (dt == null) {
      return '';
    }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(dt.seconds * 1000);
    return DateFormat('yyyy-MM-dd h:m:s').format(time);
  }

  /// Scrolls down to the bottom when,
  /// * chat room is loaded (only one time.)
  /// * when I chat,
  /// * when there is a new chat and the scroll-position is near to bottom. It does not scroll down when the scroll-position is not at the botoom.
  scrollToBottomOnLoad() {
    if (firstFetch == false && chat.messages.length > 0) {
      firstFetch = true;
      scrollToBottom(ms: 10);
    }
  }

  scrollToBottom({int ms = 200}) {
    /// This is needed to safely scroll to bottom after chat messages has been added.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: ms), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatting'),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Get.toNamed('chat.room_setting',
                  arguments: {'roomId': roomInfo['id']}))
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textController,
            ),
          ),
          RaisedButton(
            onPressed: () async {
              String _text = textController.text;
              textController.text = '';
              await ff.chatSendMessage(info: roomInfo, text: _text);
              scrollToBottom();
            },
            child: Text('Submit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room ID: ${roomInfo['id']}'),
              Text('Users: ${roomInfo['users']}'),
              RaisedButton(
                onPressed: () => Get.toNamed('chat.find_friend'),
                child: Text('Add Friends'),
              ),
              if (chat?.noMoreMessage == true) Text('No more messages....'),
              if (chat?.loading == true) CircularProgressIndicator(),
              chat == null || chat.messages.length == 0
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chat.messages.length,
                      itemBuilder: (_, i) {
                        Map<String, dynamic> message = chat.messages[i];
                        return ListTile(
                          title: Text(message['text'] ?? ''),
                          subtitle: Text(dateTime(message['createdAt'])),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
