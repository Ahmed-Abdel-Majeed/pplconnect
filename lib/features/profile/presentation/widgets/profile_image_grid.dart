import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'full_screen_image.dart';

class ProfileImageGrid extends StatelessWidget {
  final String userId;

  const ProfileImageGrid({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    CollectionReference posts =
        FirebaseFirestore.instance.collection('PostData');

    return FutureBuilder<QuerySnapshot>(
      future: posts.where('Uid', isEqualTo: userId).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No posts found."));
        }

        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.hasData) {
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  docs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImage(imageUrl: data["imgPost"]),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    data["imgPost"],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text("Loading..."));
      },
    );
  }
}
