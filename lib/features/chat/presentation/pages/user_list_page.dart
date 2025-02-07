import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart'; // استيراد صفحة الدردشة

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Userss').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No users found", style: TextStyle(color: Colors.white70)));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userDoc = users[index];
              var userData = userDoc.data() as Map<String, dynamic>;

int unreadMessages = (userData['unreadMessages'] is int) ? userData['unreadMessages'] : 0;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userData['profImg']),
                        backgroundColor: Colors.grey[200],
                      ),

                    if (unreadMessages > 0) ...[
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '$unreadMessages',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
                    ],
                  ),
                  title: Text(
                    userData['userName'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Tap to chat", style: TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                  onTap: () async {
                    // عند فتح صفحة الدردشة، نقوم بإخفاء الرسائل غير المقروءة
                    await FirebaseFirestore.instance
                        .collection('Userss')
                        .doc(userDoc.id)
                        .update({'unreadMessages': 0});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverId: userDoc.id,
                          receiverName: userData['userName'],
                          receiverProfilePic: userData['profImg'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
