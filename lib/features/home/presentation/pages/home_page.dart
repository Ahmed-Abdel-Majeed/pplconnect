import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pplconnect/core/navigation/app_navigator.dart';
import 'package:pplconnect/features/chat/presentation/pages/user_list_page.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../widgets/post_list.dart';
import '../widgets/stories_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, int> _commentCounts = {};

  void _updateCommentCount(String postId, int count) {
    setState(() {
      _commentCounts[postId] = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final allDataFromDB = userProvider.getUser;
    print("dddddddddddddddddddddddddd$allDataFromDB");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "pplconnect",
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
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {
              AppNavigator.push(context, UserListPage());
            },
            child: const Text("Chats", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          const StoriesWidget(),
          Expanded(
            child: PostList(
              commentCounts: _commentCounts,
              updateCommentCount: _updateCommentCount,
            ),
          ),
        ],
      ),
    );
  }
}
