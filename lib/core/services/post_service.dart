import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/post_data.dart';
import '../../data/models/user_data.dart';
import '../utils/snackbar.dart';
import 'storage.dart';

class PostService {
  upLoadPosts2HomeScreen({
    required userName,
    required imgName,
    required imgPath,
    required context,
    required description,
    required profImg,
  }) async {
    String imgPost = await StorageData().getImges(
        imgName: imgName,
        imgPath: imgPath,
        folderName: "ImgPost/${FirebaseAuth.instance.currentUser!.uid}");

    CollectionReference users =
        FirebaseFirestore.instance.collection('PostData');

    String creatAlotofPostsTo1User = const Uuid().v1();
    // إنشاء كائن يحتوي على بيانات المستخدم
    PostData postData = PostData(
        userName: userName,
        description: description,
        imgPost: imgPost,
        postId: creatAlotofPostsTo1User,
        profImg: profImg,
        uid: FirebaseAuth.instance.currentUser!.uid,
        postDate: DateTime.now(),
        likes: []);

    await users.doc(creatAlotofPostsTo1User).set(postData.convertdata2map());
    showSnackBar(context, "Post Added");
  }

  Future<UserData> getUserDetails() async {
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('Userss')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return PostData.convertdata2Model(data);
  }
}
