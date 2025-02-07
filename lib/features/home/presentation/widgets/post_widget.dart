import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatelessWidget {
  final Map<String, dynamic> postData;
  final int commentCount;

  const PostWidget({
    super.key,
    required this.postData,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final formattedDate = _formatDate(postData['postDate']);

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
          _buildPostHeader(),
          _buildPostImage(),
          _buildInteractionButtons(),
          _buildPostDescription(formattedDate),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(postData["profImg"].toString()),
              ),
              const SizedBox(width: 10),
              Text(postData["userName"]??"",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
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
      child: Image.asset(
        "assets/images/signup.png",
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInteractionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                onPressed: () {},
              ),
              _buildCommentButton(),
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

  Widget _buildCommentButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.comment, color: Colors.lightBlue),
          onPressed: () {},
        ),
        Positioned(
          right: 0,
          child: Container(
            width: 20,
            height: 22,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 7, 136, 211),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$commentCount",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
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
            "${postData['likedBy']?.length ?? 0} ${postData['likedBy'] != null && postData['likedBy'].length > 1 ? "Likes" : "Like"}",
            style: const TextStyle(color: Colors.grey),
          ),
          Text("ssssss",
              style: const TextStyle(color: Colors.grey)),
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

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('dd-MM-yyyy hh:mm a').format(date);
    }
    return 'Unknown date';
  }
}




