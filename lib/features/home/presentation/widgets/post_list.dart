import 'package:flutter/material.dart';
import 'post_widget.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> posts = [
      {
        'title': 'First Post',
        'content': 'This is the content of the first post.',
        'author': 'User1'
      },
      {
        'title': 'Second Post',
        'content': 'Another post with some interesting content.',
        'author': 'User2'
      },
      {
        'title': 'Third Post',
        'content': 'Yet another insightful post.',
        'author': 'User3'
      },
    ];

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostWidget(
          postData: posts[index],
          commentCount: 0, 
        );
      },
    );
  }
}
