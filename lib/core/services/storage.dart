import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/snackbar.dart';

class StorageData {
  getImges({
    required String imgName,
    required Uint8List imgPath,
    required String folderName,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref("$folderName/$imgName");
      UploadTask uploadTask = storageRef.putData(imgPath);

      TaskSnapshot snap = await uploadTask;

      String url = await snap.ref.getDownloadURL();
      return url;
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
      return '';
    }
  }

addComment({
  required context,
  required postDataInHomeScreen,
  required commentId,
  required commentController,
}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final allDataFromDB = userProvider.getUser;

  if (allDataFromDB == null) {
    // إضافة سجل للتصحيح في الـ Debug Console
    if (kDebugMode) {
      print("User data is null. Ensure that UserProvider is updated correctly.");
    }
    showSnackBar(context, "User data is not available. Please log in again.");
    return;
  }

  await FirebaseFirestore.instance
      .collection("PostData")
      .doc(postDataInHomeScreen["postId"])
      .collection("Comments")
      .doc(commentId)
      .set({
    "userName": allDataFromDB.userName,
    "comment": commentController.text,
    "date": DateTime.now(),
    "profImg": allDataFromDB.profImg,
    "uid": allDataFromDB.uid,
  });
  commentController.clear();
}

  void commentLikes(
      {required commentId,
      required commentData,
      required postDataInHomeScreen}) async {
    final user = FirebaseAuth.instance.currentUser;

    final commentRef = FirebaseFirestore.instance
        .collection('PostData')
        .doc(postDataInHomeScreen["postId"])
        .collection("Comments")
        .doc(commentId);

    List likedBy = commentData['likedBy'] ?? [];

    if (likedBy.contains(user!.uid)) {
      await commentRef.update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([user.uid]),
      });
    } else {
      await commentRef.update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([user.uid]),
      });
    }
  }

void togglePostLike({
  required String postId,
  required Map<String, dynamic> postData,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print('User is not logged in');
    return;
  }

  final postRef = FirebaseFirestore.instance
      .collection('PostData')
      .doc(postId);

  List likedBy = postData['likedBy'] ?? [];

  if (likedBy.contains(user.uid)) {
    await postRef.update({
      'likes': FieldValue.increment(-1),
      'likedBy': FieldValue.arrayRemove([user.uid]),
    });
  } else {
    await postRef.update({
      'likes': FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([user.uid]),
    });
  }
}


}
