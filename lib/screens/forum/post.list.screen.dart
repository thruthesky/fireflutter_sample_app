import 'package:fireflutter/fireflutter.dart';
import 'package:fireflutter_sample_app/global_variables.dart';
import 'package:fireflutter_sample_app/screens/forum/comment.dart';
import 'package:fireflutter_sample_app/screens/forum/comment.form.dart';
import 'package:fireflutter_sample_app/screens/forum/display_photos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumListScreen extends StatefulWidget {
  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  String category;

  ForumData forum;
  ScrollController scrollController = ScrollController();

  /// Check if the scroll is at the bottom of the page
  bool get atBottom =>
      scrollController.offset >
      (scrollController.position.maxScrollExtent - 200);

  @override
  void initState() {
    super.initState();
    category = Get.arguments['category'];
    forum = ForumData(
      category: category,
      render: (RenderType x) {
        if (mounted) setState(() {});
      },
    );

    ff.fetchPosts(forum);
    scrollController.addListener(onScrollToBottom);
  }

  ///
  onScrollToBottom() {
    if (!atBottom) return;
    ff.fetchPosts(forum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Get.toNamed('forum-edit', arguments: {'category': category}),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: forum.posts.length,
                itemBuilder: (context, i) {
                  Map<String, dynamic> post = forum.posts[i];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostSubject(post: post),
                      PostContent(post: post),
                      DisplayPhotos(
                        document: post,
                      ),
                      PostButtons(post: post),
                      Divider(),
                      CommentForm(post: post),
                      if (post['comments'] != null)
                        for (int j = 0; j < post['comments'].length; j++)
                          Comment(post: post, index: j),
                    ],
                  );
                },
              ),
              if (forum.inLoading) CircularProgressIndicator(),
              if (forum.status == ForumStatus.noPosts)
                Text('No post exists in this forum.'),
              if (forum.status == ForumStatus.noMorePosts)
                Text('There is no more post.'),
            ],
          ),
        ),
      ),
    );
  }
}

class PostButtons extends StatelessWidget {
  const PostButtons({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PostEditButton(post: post),
        RaisedButton(
          onPressed: () async {
            try {
              await ff.vote(
                postId: post['id'],
                choice: VoteChoice.like,
              );
            } catch (e) {
              Get.snackbar('Error', e.toString());
            }
          },
          child: Text('Like ${post['likes'] ?? ''}'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await ff.vote(
                postId: post['id'],
                choice: VoteChoice.dislike,
              );
            } catch (e) {
              Get.snackbar('Error', e.toString());
            }
          },
          child: Text('Dislike ${post['dislikes'] ?? ''}'),
        ),
      ],
    );
  }
}

class PostEditButton extends StatelessWidget {
  const PostEditButton({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => Get.toNamed(
        'forum-edit',
        arguments: {'post': post},
      ),
      child: Text('Edit'),
    );
  }
}

class PostContent extends StatelessWidget {
  const PostContent({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(post['content']),
      color: Colors.grey[200],
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      width: double.infinity,
    );
  }
}

class PostSubject extends StatelessWidget {
  const PostSubject({
    Key key,
    @required this.post,
  }) : super(key: key);

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post['title'],
          style: TextStyle(fontSize: 22),
        ),
        Text(
          post['id'],
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
