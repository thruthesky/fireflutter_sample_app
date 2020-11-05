import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:fireflutter_sample_app/screens/forum/comment.form.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Comment extends StatefulWidget {
  const Comment({
    Key key,
    @required this.post,
    this.index,
  }) : super(key: key);

  final Map<String, dynamic> post;
  final int index;

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool edit = false;
  Map<String, dynamic> comment;
  @override
  Widget build(BuildContext context) {
    comment = widget.post['comments'][widget.index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment['id'],
          style: TextStyle(
            fontSize: 10,
          ),
        ),
        edit
            ? CommentForm(
                post: widget.post,
                comment: comment,
                onCancel: () => setState(() => edit = false),
                onSuccess: () => setState(() => edit = false),
              )
            : Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: 16, left: comment['depth'] * 32.0),
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Text(comment['content'],
                        style: TextStyle(fontSize: 16)),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setState(() => edit = true),
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await ff.deleteComment(
                              widget.post['id'],
                              comment['id'],
                            );
                          } catch (e) {
                            Get.snackbar('Error', e.toString());
                          }
                        },
                        child: Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await ff.vote(
                              postId: widget.post['id'],
                              commentId: comment['id'],
                              choice: VoteChoice.like,
                            );
                          } catch (e) {
                            Get.snackbar('Error', e.toString());
                          }
                        },
                        child: Text('Like ${comment['likes'] ?? ''}'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await ff.vote(
                              postId: widget.post['id'],
                              commentId: comment['id'],
                              choice: VoteChoice.dislike,
                            );
                          } catch (e) {
                            Get.snackbar('Error', e.toString());
                          }
                        },
                        child: Text('Dislike ${comment['dislikes'] ?? ''}'),
                      ),
                    ],
                  ),
                  CommentForm(
                    post: widget.post,
                    parentIndex: widget.index,
                  )
                ],
              ),
      ],
    );
  }
}
