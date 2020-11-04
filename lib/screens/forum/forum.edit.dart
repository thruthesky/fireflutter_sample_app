import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumEditScreen extends StatefulWidget {
  @override
  _ForumEditScreenState createState() => _ForumEditScreenState();
}

class _ForumEditScreenState extends State<ForumEditScreen> {
  /// Text box controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  /// Category ID
  String category;

  /// Post to edit
  Map<String, dynamic> post;

  @override
  void initState() {
    super.initState();

    /// If `category` is passed, then it is post create.
    if (Get.arguments['category'] != null) {
      category = Get.arguments['category'];
    } else {
      /// Or it's post update.
      post = Get.arguments['post'];
      titleController.text = post['title'];
      contentController.text = post['content'];
      category = post['category'];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  bool get formInvalid => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Edit'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'title'),
          ),
          TextFormField(
            controller: contentController,
            decoration: InputDecoration(hintText: 'content'),
          ),
          Row(
            children: [
              RaisedButton(
                onPressed: () async {
                  if (formInvalid) {
                    return Get.snackbar('title', 'message');
                  }
                  try {
                    await ff.editPost({
                      'id': post == null ? null : post['id'],
                      'category': category,
                      'title': titleController.text,
                      'content': contentController.text,
                      'uid': ff.user.uid,
                    });

                    /// Should go back since new post will be updated in real time.
                    Get.back();
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
                child: Text('submit'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
