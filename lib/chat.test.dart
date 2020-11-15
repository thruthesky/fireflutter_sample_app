import 'package:fireflutter/functions.dart';
import 'package:fireflutter_sample_app/global_variables.dart';

class ChatTest {
  Map<String, Map<String, String>> users = {
    'a': {'uid': 'xbTphnD5QBejlDuBgDK2hXmUxp62', 'displayName': 'UserA'},
    'b': {'uid': 'g3bJ3C3BiZYe9AhLPbtjJASB9622', 'displayName': 'UserB'},
    'c': {'uid': 'QlymWR6GSYOWzHKq92S4ErNSMzH3', 'displayName': 'UserC'},
    'd': {'uid': '9tRhNodWtpRuDI9isvi4DCbc7xC2', 'displayName': 'UserD'},
    'xbTphnD5QBejlDuBgDK2hXmUxp62': {'email': 'aaaa@gmail.com'},
    'g3bJ3C3BiZYe9AhLPbtjJASB9622': {'email': 'bbbb@gmail.com'},
    'QlymWR6GSYOWzHKq92S4ErNSMzH3': {'email': 'cccc@gmail.com'},
    '9tRhNodWtpRuDI9isvi4DCbc7xC2': {'email': 'dddd@gmail.com'},
  };

  Map<String, String> userA = {
    'email': 'aaaa@gmail.com',
    'password': '12345a,*',
    'displayName': 'UserA'
  };
  Map<String, String> userB = {
    'email': 'bbbb@gmail.com',
    'password': '12345a,*',
    'displayName': 'UserB'
  };
  Map<String, String> userC = {
    'email': 'cccc@gmail.com',
    'password': '12345a,*',
    'displayName': 'UserC'
  };
  Map<String, String> userD = {
    'email': 'dddd@gmail.com',
    'password': '12345a,*',
    'displayName': 'UserD'
  };

  /// login or register user A, B, C, D.
  ///
  /// Once it has logged in, it prints the UID and DisplayName of the users.
  /// You need to save the user UID and DisplayName into [users] variable.
  prepareUserABCD() async {
    if (users != null) return;
    dynamic a = await ff.loginOrRegister(userA);
    dynamic b = await ff.loginOrRegister(userB);
    dynamic c = await ff.loginOrRegister(userC);
    dynamic d = await ff.loginOrRegister(userD);
    print("{'uid': '${a.uid}', 'displayName': 'a.displayName'}");
    print("{'uid': '${b.uid}', 'displayName': 'b.displayName'}");
    print("{'uid': '${c.uid}', 'displayName': 'c.displayName'}");
    print("{'uid': '${d.uid}', 'displayName': 'd.displayName'}");
  }

  success(String message) {
    print("[SUCCESS] $message");
  }

  failture(String message) {
    print("[FAILURE] $message");
  }

  isTrue(bool re, [String message]) {
    if (re)
      success(message);
    else
      failture(message);
  }

  run() {
    ff.firebaseInitialized.listen((value) async {
      if (!value) return;

      prepareUserABCD();

      await ff.login(email: userA['email'], password: userA['password']);

      print('${users['a']['displayName']} -> ${users['a']['uid']}');
      print('${users['b']['displayName']} -> ${users['b']['uid']}');
      print('${users['c']['displayName']} -> ${users['c']['uid']}');
      print('${users['d']['displayName']} -> ${users['d']['uid']}');

      /// Chat room creation test
      Map<String, dynamic> roomInfo = await ff.chatCreateRoom();
      Map<String, dynamic> info = await ff.chatGetRoomInfo(roomInfo['id']);
      isTrue(info['moderators'].length == 1, 'moderators length must be 1');
      isTrue(info['moderators'][0] == users['a']['uid'],
          'user A must be the moderator - ${users['a']['uid']}');

      roomInfo = await ff.chatCreateRoom(users: [users['b']['uid']]);
      info = await ff.chatGetRoomInfo(roomInfo['id']);

      isTrue(info['users'].length == 2, 'users.length should be 2');
      isTrue(info['users'].indexOf(users['a']['uid']) > -1,
          'user A - ${users['a']['uid']} must be in users array');
      isTrue(info['users'].indexOf(users['b']['uid']) > -1,
          'user B - ${users['b']['uid']} must be in users array');

      roomInfo = await ff
          .chatCreateRoom(users: [users['b']['uid'], users['c']['uid']]);

      info = await ff.chatGetRoomInfo(roomInfo['id']);
      isTrue(info['users'].length == 3, 'users.length should be 3');

      roomInfo = await ff.chatCreateRoom(users: [
        users['b']['uid'],
        users['b']['uid'],
        users['b']['uid'],
        users['c']['uid'],
        users['c']['uid'],
        users['c']['uid'],
        users['d']['uid']
      ]);

      info = await ff.chatGetRoomInfo(roomInfo['id']);
      isTrue(info['users'].length == 4, 'users.length should be 4');
      isTrue(info['users'].indexOf(users['a']['uid']) > -1,
          'user A - ${users['a']['uid']} must be in users array');
      isTrue(info['users'].indexOf(users['b']['uid']) > -1,
          'user B - ${users['b']['uid']} must be in users array');
      isTrue(info['users'].indexOf(users['c']['uid']) > -1,
          'user C - ${users['c']['uid']} must be in users array');
      isTrue(info['users'].indexOf(users['d']['uid']) > -1,
          'user D - ${users['d']['uid']} must be in users array');

      /// User add to chat room

      roomInfo = await ff.chatCreateRoom(users: [users['b']['uid']]);
      info = await ff.chatGetRoomInfo(roomInfo['id']);
      isTrue(info['users'].length == 2,
          'Add user: users.length==2. roomId: ${roomInfo['id']}');
      await ff.chatAddUser(roomInfo, [users['c']['uid']]);
      info = await ff.chatGetRoomInfo(roomInfo['id']);
      List _users = info['users'];
      isTrue(
          _users.toSet().containsAll([
            users['c']['uid'],
            users['b']['uid'],
            users['a']['uid'],
          ]),
          'A, B, C are included.');
      isTrue(
          !_users.toSet().containsAll([
            users['d']['uid'],
          ]),
          'D are not included.');

      /// Send chat message
      ///
      String text = "Yo! " + getRandomString();
      await ff.chatSendMessage(info: info, text: text);
      for (String uid in info['users']) {
        print('get: uid:$uid, ${ff.chatUserRoomDoc(uid, info['id']).path}');
        await ff.login(email: users[uid]['email'], password: '12345a,*');
        Map<String, dynamic> room =
            (await ff.chatUserRoomDoc(uid, info['id']).get()).data();

        isTrue(room['text'] == text, 'Chat text comparison: $text');
      }

      /// Moderator adds another moderators.
    });
  }
}
