import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/navigation/app_navigator.dart';
import '../../profile/presentation/pages/profile_page.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعجابات"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('PostData').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد إعجابات بعد!"));
          }

          List<DocumentSnapshot> posts = snapshot.data!.docs;

          List<Widget> likesWidgets = [];

          for (var post in posts) {
            var postData = post.data() as Map<String, dynamic>;
            print("ssssssssssssssssssssssssss$postData");

            if (postData["likedBy"] != null && postData["likedBy"].isNotEmpty) {
              for (var like in postData["likedBy"]) {
                var postDate = postData["postDate"];
                String postDateText = postDate != null ? postDate.toDate().toString() : "غير متوفر";

                likesWidgets.add(
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(postData["profImg"]),
                      ),
                      title: Text(postData["userName"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textDirection: TextDirection.rtl,
                            "أُعجب بمنشور: ${postData["description"]}"),
                    
                        ],
                      ),
                      onTap: () {
                                                AppNavigator.push(context, ProfilePage(userId: postData["Uid"]));

                      },
                    ),
                  ),
                );
              }
            }
          }

          return likesWidgets.isNotEmpty
              ? ListView(children: likesWidgets)
              : const Center(child: Text("لا توجد إعجابات بعد!"));
        },
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ملف الشخص"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('UserData').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("لا يوجد بيانات لهذا المستخدم"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData["profImg"] ?? ''),
                ),
                const SizedBox(height: 16),
                Text("الاسم: ${userData["userName"]}", style: Theme.of(context).textTheme.titleLarge),
                Text("البريد الإلكتروني: ${userData["email"]}"),
                Text("رقم الهاتف: ${userData["phoneNumber"]}"),
                // يمكنك إضافة المزيد من الحقول هنا حسب الحاجة
              ],
            ),
          );
        },
      ),
    );
  }
}
