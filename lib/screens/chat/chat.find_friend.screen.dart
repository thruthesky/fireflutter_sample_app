import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatFindFriendScreen extends StatefulWidget {
  @override
  _ChatFindFriendScreenState createState() => _ChatFindFriendScreenState();
}

class _ChatFindFriendScreenState extends State<ChatFindFriendScreen> {
  List<Map<String, dynamic>> users = [];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final snapshot = await ff.metaUserPublic.get();
    snapshot.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data['uid'] = element.id;
      users.add(data);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Friend'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (_, i) {
              return ListTile(
                title: Text(users[i]['displayName'] ?? ''),
                subtitle: Text(users[i]['uid']),
                trailing: Icon(Icons.add),
                onTap: () async {
                  if (Get.arguments != null &&
                      Get.arguments['roomId'] != null) {
                    try {
                      await ff.chatAddUser(Get.arguments['roomId'],
                          {users[i]['uid']: users[i]['displayName'] ?? ''});
                      Get.back();
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  } else {
                    /// todo create room here and enter the room.
                    Get.toNamed('chat.room',
                        arguments: {'uid': users[i]['uid']});
                  }
                },
              );
            },
          )
        ]),
      ),
    );
  }
}
