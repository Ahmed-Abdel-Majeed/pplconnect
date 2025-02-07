import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/comment_item.dart';
import '../widgets/comment_input.dart';

class CommentsPage extends StatefulWidget {
  final Map postDataInHomeScreen;
  const CommentsPage({super.key, required this.postDataInHomeScreen});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<int> _getCommentCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('PostData')
        .doc(widget.postDataInHomeScreen["postId"])
        .collection("Comments")
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> commentsStream = FirebaseFirestore.instance
        .collection('PostData')
        .doc(widget.postDataInHomeScreen["postId"])
        .collection("Comments")
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            int count = await _getCommentCount();
            Navigator.pop(context, count);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: commentsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong', style: TextStyle(color: Colors.white)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return CommentItem(
                      document: document,
                      postDataInHomeScreen: widget.postDataInHomeScreen,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const Divider(color: Colors.grey),
          CommentInput(postDataInHomeScreen: widget.postDataInHomeScreen),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
