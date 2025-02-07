import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/storage.dart';

class CommentInput extends StatefulWidget {
  final Map postDataInHomeScreen;

  const CommentInput({super.key, required this.postDataInHomeScreen});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController commentController = TextEditingController();

  String commentId = const Uuid().v1();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.cyanAccent),
            onPressed: () {
              // إضافة التعليق باستخدام دالة من StorageData (يجب التأكد من تنفيذها في firebase_service/storage.dart)
              StorageData().addComment(
                postDataInHomeScreen: widget.postDataInHomeScreen,
                commentId: commentId,
                commentController: commentController,
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
