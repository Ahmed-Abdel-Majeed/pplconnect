import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/snackbar.dart';
import '../widgets/edit_profile_background.dart';
import '../widgets/edit_profile_inputs.dart';
import '../widgets/edit_profile_save_button.dart';
import '../widgets/edit_profile_post_list.dart';

class EditProfileScreen extends StatefulWidget {
  final Map profileData;

  const EditProfileScreen({super.key, required this.profileData});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.profileData['userName'] ?? '';
    bioController.text = widget.profileData['userBio'] ?? '';
    passwordController.text = widget.profileData['password'] ?? '';
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String userId = currentUser!.uid;

      // تحديث البيانات في Firestore
      await FirebaseFirestore.instance.collection('Userss').doc(userId).update({
        'userName': nameController.text,
        'userBio': bioController.text,
      });

      // تحديث كلمة المرور (إذا تم إدخال قيمة)
      if (passwordController.text.isNotEmpty) {
        await currentUser.updatePassword(passwordController.text);
      }

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Error updating profile: $e");
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('PostData').doc(postId).delete();
      showSnackBar(context, "Post deleted successfully");
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting post: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const EditProfileBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                EditProfileInputs(
                  nameController: nameController,
                  bioController: bioController,
                  passwordController: passwordController,
                ),
                const SizedBox(height: 20),
                EditProfileSaveButton(
                  isLoading: isLoading,
                  onPressed: updateProfile,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: EditProfilePostList(
                    onDeletePost: deletePost,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
