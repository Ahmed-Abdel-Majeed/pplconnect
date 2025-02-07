import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/services/firebase_service.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/edit_profile_button.dart';
import '../widgets/profile_image_grid.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  bool isFollowing = false;
  Map profileData = {};
  int followers = 0;
  int following = 0;
  int postCount = 0;
  bool isCurrentUser = true;

  void checkCurrentUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        isCurrentUser = widget.userId == currentUser.uid;
      });
    }
  }

  Future<void> getDataFromFirestore() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Userss')
          .doc(widget.userId)
          .get();

      profileData = data.data()!;
      following = data["following"].length;
      followers = data["followers"].length;

      var getPostCount = await FirebaseFirestore.instance
          .collection("PostData")
          .where("Uid", isEqualTo: widget.userId)
          .get();

      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        isFollowing = data["followers"].contains(currentUser.uid);
      }

      setState(() {
        postCount = getPostCount.docs.length;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleFollow() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (isFollowing) {
        await FirebaseFirestore.instance
            .collection('Userss')
            .doc(currentUser.uid)
            .update({
          "following": FieldValue.arrayRemove([widget.userId])
        });

        await FirebaseFirestore.instance
            .collection('Userss')
            .doc(widget.userId)
            .update({
          "followers": FieldValue.arrayRemove([currentUser.uid])
        });

        setState(() {
          isFollowing = false;
          followers--;
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Userss')
            .doc(currentUser.uid)
            .update({
          "following": FieldValue.arrayUnion([widget.userId])
        });

        await FirebaseFirestore.instance
            .collection('Userss')
            .doc(widget.userId)
            .update({
          "followers": FieldValue.arrayUnion([currentUser.uid])
        });

        setState(() {
          isFollowing = true;
          followers++;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirestore();
    checkCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading:isCurrentUser? IconButton(onPressed: () {
                                    setState(() {
                                      AuthService().signOut();
                                    });

              },
              
                icon: Icon(
                  isCurrentUser ? Icons.logout : Icons.logout,
                ),
              ):null,
            ),
            extendBodyBehindAppBar: true,
            body: RefreshIndicator(
              onRefresh: getDataFromFirestore,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    ProfileHeader(profileData: profileData),
                    const SizedBox(height: 20),
                    ProfileStats(
                      postCount: postCount,
                      followers: followers,
                      following: following,
                      userId: widget.userId,
                    ),
                    const SizedBox(height: 20),
                    EditProfileButton(
                      isCurrentUser: isCurrentUser,
                      isFollowing: isFollowing,
                      onEdit: () {
                        if (isCurrentUser) {
                          AppNavigator.push(
                            context,
                            EditProfileScreen(profileData: profileData),
                          );
                        } else {
                          toggleFollow();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(child: ProfileImageGrid(userId: widget.userId)),
                    const Align(
                      alignment: Alignment.bottomCenter,
                
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
