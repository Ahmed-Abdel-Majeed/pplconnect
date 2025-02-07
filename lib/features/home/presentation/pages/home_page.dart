import 'package:flutter/material.dart';

import '../widgets/post_list.dart';
import '../widgets/stories_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: const Column(
        children: [
          StoriesWidget(),
          Expanded(child: PostList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "pplconnect_1",
        style: TextStyle(
          fontFamily: "Butcherman",
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
          onPressed: () {}, // Add functionality later
        ),
        TextButton(
          onPressed: () {}, // Add navigation later
          child: const Text("Chats", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}