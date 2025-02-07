import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_page.dart';

class FollowersFollowingScreen extends StatelessWidget {
  final String userId;
  final bool isFollowing; // لتحديد ما إذا كنا نعرض المتابعين أو الذين نتابعهم

  const FollowersFollowingScreen({
    super.key,
    required this.userId,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isFollowing ? 'Following' : 'Followers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<String>>(
        future: _getFollowersOrFollowing(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    "No ${isFollowing ? 'following' : 'followers'} found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              String uid = snapshot.data![index];
              return ListTile(
                leading: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Userss')
                      .doc(uid)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircleAvatar(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError) {
                      return const CircleAvatar(child: Icon(Icons.error));
                    }

                    var userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;
                    if (userData == null) {
                      return const CircleAvatar(child: Icon(Icons.error));
                    }

                    String imageUrl = userData["profImg"] ??
                        ''; // تأكد من وجود هذا الحقل
                    return CircleAvatar(
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null, // إذا لم يكن هناك صورة، عرض أيقونة
                    );
                  },
                ),
                title: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Userss')
                      .doc(uid)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text("Loading...");
                    }

                    if (userSnapshot.hasError) {
                      return const Text("Error loading user");
                    }

                    var userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;
                    if (userData == null) {
                      return const Text("User data not found");
                    }

                    return Text(userData["userName"] ?? 'Unknown User');
                  },
                ),
                onTap: () {
                  // التنقل إلى صفحة ملف المستخدم
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(userId: uid),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getFollowersOrFollowing() async {
    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('Userss').doc(userId).get();
    return isFollowing
        ? List.from(userData["following"] ?? [])
        : List.from(userData["followers"] ?? []);
  }
}
