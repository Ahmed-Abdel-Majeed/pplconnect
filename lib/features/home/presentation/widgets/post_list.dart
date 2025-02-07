import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'post_widget.dart';

class PostList extends StatelessWidget {
  final Map<String, int> commentCounts;
  final Function(String, int) updateCommentCount;

  const PostList({
    super.key,
    required this.commentCounts,
    required this.updateCommentCount,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('PostData').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading posts', style: TextStyle(color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final document = snapshot.data!.docs[index];
            return PostWidget(
              postData: document.data() as Map<String, dynamic>,
              postId: document.id,
              commentCount: commentCounts[document.id] ?? 0,
              updateCommentCount: updateCommentCount,
            );
          },
        );
      },
    );
  }
}
