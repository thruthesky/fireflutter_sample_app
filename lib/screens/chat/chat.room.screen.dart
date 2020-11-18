import 'dart:async';

import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

///
/// todo display proper error message on permission denied. like when user tries to block another user. it must be doen by a moderator.
/// todo when a user is blocked from a chat room, then the chat room should be automatically closed if the user is in and the room in room list should be deleted.
/// todo document logic - when a user is in chat room and blocked by moderator, the user received no more messages except the [chat:blocked] message.
/// todo docuemnt logic - when a user is blocked, no can add the user again until moderator removes the user from `blockedUsers` property.
///
class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final textController = TextEditingController();
  ChatRoom chat;
  final scrollController = ScrollController();
  bool firstFetch = false;

  StreamSubscription keyboardSubscription;

  String get title {
    if (chat.info == null) return 'Chatting Room';
    String _title = '';
    if (chat.info['users'].length > 0)
      _title += "[${chat.info['users'].length}] ";
    if (chat.info['title'] != null) _title += chat.info['title'];

    return _title;
  }

  String messageText(Map<String, dynamic> message) {
    String text = message['text'] ?? '';
    if (text == Chat.roomCreated) {
      text = 'Chat room created. ';
    }

    /// Display `no more messages` only when user scrolled up to see more messages.
    else if (chat.page > 1 && chat.noMoreMessage) {
      text = 'No more messages. ';
    } else if (text == Chat.enter) {
      print(message);
      text = "${message['senderDisplayName']} invited ${message['newUsers']}";
    } else {}

    return text;
  }

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
    String roomId;

    /// Entering into room
    if (Get.arguments['info'] != null) {
      roomId = Get.arguments['info']['id'];
    } else {
      /// Create a room with the user.
      var roomInfo = await ff.chatCreateRoom(users: [Get.arguments['uid']]);
      roomId = roomInfo['id'];
    }

    setState(() {});

    chat = ChatRoom(
        inject: ff,
        roomId: roomId,
        render: () {
          setState(() {});
          if (chat.messages.isNotEmpty) {
            if (!firstFetch) {
              scrollToBottomOnLoad();
            } else if (atBottom) {
              scrollToBottom();
            }
          }
        });

    scrollController.addListener(() {
      if (scrollUp && atTop) {
        chat.fetchMessages();
      }
    });

    keyboardSubscription = KeyboardVisibility.onChange.listen((bool visible) {
      if (visible && atBottom) {
        scrollToBottom();
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
  /// * when new chat is coming and the page is scrolled near to bottom. Logically it should not scroll down when the page is scrolled far from the bottom.
  /// * when keyboard is open and the page scroll is near to bottom. Locally it should not scroll down when the user is reading message that is far from the bottom.
  scrollToBottomOnLoad() {
    if (firstFetch == false && chat.messages.length > 0) {
      firstFetch = true;
      scrollToBottom(ms: 10);
    }
  }

  scrollToBottom({int ms = 200}) {
    /// This is needed to safely scroll to bottom after chat messages has been added.

    Timer(Duration(milliseconds: ms), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: ms), curve: Curves.ease);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    chat.leave();
    keyboardSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Get.toNamed('chat.find_friend',
                  arguments: {'roomId': chat.info['id']})),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Get.toNamed('chat.room_setting',
                  arguments: {'roomId': chat.info['id']}))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Room ID: ${chat?.info != null ? chat.info['id'] : ''}'),
            // Text(
            //     'Users: ${chat?.info != null ? chat.info['users']?.length : ''}'),
            // RaisedButton(
            //   onPressed: () => Get.toNamed('chat.find_friend', arguments: {'roomId': chat.info['id']}),
            //   child: Text('Add Friends'),
            // ),
            // if (chat?.noMoreMessage == true) Text('No more messages....'),
            if (chat?.loading == true) CircularProgressIndicator(),
            chat == null || chat.messages.length == 0
                ? CircularProgressIndicator()
                : Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: chat.messages.length,
                          itemBuilder: (_, i) {
                            Map<String, dynamic> message = chat.messages[i];
                            return ListTile(
                              title: Text(messageText(message)),
                              subtitle: Text(
                                'By ${message['senderDisplayName']} ${message['id']} ' +
                                    dateTime(message['createdAt']),
                                style: TextStyle(fontSize: 8),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () async {
                                  try {
                                    await ff.chatBlockUser(
                                      chat.info['id'],
                                      message['senderUid'],
                                      message['senderDisplayName'],
                                    );
                                    Get.snackbar('User blocked',
                                        "${message['senderDisplayName']} has been blocked.");
                                  } catch (e) {
                                    Get.snackbar('Error', e.toString());
                                  }
                                },
                              ),
                            );
                          }),
                    ),
                  ),
            SafeArea(
              child: Row(
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
                      await ff.chatSendMessage(info: chat.info, text: _text);
                      // ? Most of chat app (like Kakao) does not close keyboard after chat message has been sent.
                      // FocusManager.instance.primaryFocus.unfocus();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
