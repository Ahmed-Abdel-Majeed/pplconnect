import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/storage.dart';

class CommentItem extends StatelessWidget {
  final DocumentSnapshot document;
  final Map postDataInHomeScreen;

  const CommentItem({
    super.key,
    required this.document,
    required this.postDataInHomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> commentData = document.data()! as Map<String, dynamic>;

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
        .format((commentData['date'] as Timestamp).toDate());

    bool isLiked = commentData['likedBy'] != null &&
        commentData['likedBy'].contains(user!.uid);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(commentData['profImg']),
      ),
      title: Text(
        commentData['userName'],
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(commentData['comment'], style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          Text(formattedDate, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.pinkAccent : Colors.grey,
                ),
                onPressed: () {
                  // استدعاء دالة الإعجاب الموجودة في StorageData
                  StorageData().commentLikes(
                    commentId: document.id,
                    commentData: commentData,
                    postDataInHomeScreen: postDataInHomeScreen,
                  );
                },
              ),
              Text(
                '${commentData['likes'] ?? 0} likes',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
