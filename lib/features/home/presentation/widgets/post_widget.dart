import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pplconnect/features/profile/presentation/pages/profile_page.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/services/storage.dart';
import '../../../comment/presentation/pages/comments_page.dart';

class PostWidget extends StatefulWidget {
  final Map<String, dynamic> postData;
  final String postId;
  final int commentCount;
  final Function(String, int) updateCommentCount;

  const PostWidget({
    super.key,
    required this.postData,
    required this.postId,
    required this.commentCount,
    required this.updateCommentCount,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final formattedDate = _formatDate(widget.postData['postData']);

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: widthScreen > 600 ? widthScreen / 3 : 10,
        vertical: 5,
      ),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(context),
          _buildPostImage(widthScreen),
          _buildInteractionRow(context),
          _buildPostDescription(formattedDate),
        ],
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToProfile(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.postData["profImg"]),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.postData["userName"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage(double widthScreen) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Image.network(
        widget.postData["imgPost"],
        height: 300,
        width: widthScreen * 0.999999,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInteractionRow(BuildContext context) {
    final isLiked = _checkIfLiked();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.pinkAccent,
                ),
                onPressed: () => _toggleLike(),
              ),
              _buildCommentButton(context),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.cyanAccent),
                onPressed: () {},
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("PostData")
          .doc(widget.postId)
          .collection("Comments")
          .snapshots(),
      builder: (context, snapshot) {
        int count = 0;
        if (snapshot.hasData) {
          count = snapshot.data!.docs.length;
        }
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.comment, color: Colors.lightBlue),
              onPressed: () => _navigateToComments(context),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 7, 136, 211),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$count",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostDescription(String formattedDate) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.postData['likedBy']?.length ?? 0} ${widget.postData['likedBy'] != null && widget.postData['likedBy'].length > 1 ? "Likes" : "Like"}",
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            widget.postData["description"],
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  bool _checkIfLiked() {
    return widget.postData['likedBy'] != null &&
        widget.postData['likedBy'].contains(FirebaseAuth.instance.currentUser!.uid);
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return 'Unknown date';
    return DateFormat('dd-MM-yyyy hh:mm a').format(timestamp.toDate());
  }

  void _toggleLike() {
    StorageData().togglePostLike(
      postId: widget.postData["postId"],
      postData: widget.postData,
    );
  }

  void _navigateToProfile(BuildContext context) {
    AppNavigator.push(context, ProfilePage(userId: widget.postData["Uid"]));
  }

  void _navigateToComments(BuildContext context) {
    AppNavigator.push(context, CommentsPage(postDataInHomeScreen: widget.postData));
  }
}
