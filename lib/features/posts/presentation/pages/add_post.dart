// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

import '../../../../core/providers/user_provider.dart';
import '../../../../core/services/post_service.dart';
import '../../../../core/utils/snackbar.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? imgPath;
  String? imgName;
  bool isSelected = true;
  Map profileData = {};
  bool isLoading = false;
  final descriptionController = TextEditingController();

  getDataFromFireStorre() async {
    setState(() {});
    try {
      DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Userss')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      profileData = data.data()!;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allUserDataFromDB = Provider.of<UserProvider>(context).getUser;

    final double widthScreen = MediaQuery.of(context).size.width;

    Future<void> uploadImage(ImageSource source) async {
      final pickedImg = await ImagePicker().pickImage(source: source);
      try {
        if (pickedImg != null) {
          imgPath = await pickedImg.readAsBytes();

          showSnackBar(context, "image Sclected");

          setState(() {
            // imgPath = File(pickedImg.path).readAsBytesSync();
            imgName = basename(pickedImg.path);
            int random = Random().nextInt(108800);
            imgName = "$random$imgName";
          });
        } else {
          showSnackBar(context, "No image selected.");
        }
      } catch (e) {
        showSnackBar(context, "Error occurred while picking image: $e");
      }
    }

    void showImageSourceOptions() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    uploadImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    uploadImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return imgPath != null
        ? SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset:
                  false, // امنع الشاشة من التمدد لما يظهر الكيبورد

              // خلفية متدرجة بين الأزرق والأبيض
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.blueAccent, // لون شريط التطبيق الأزرق
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await PostService().upLoadPosts2HomeScreen(
                          userName: allUserDataFromDB!.userName,
                          imgName: imgName,
                          imgPath: imgPath,
                          context: context,
                          description: descriptionController.text,
                          profImg: allUserDataFromDB.profImg);
                      setState(() {
                        isLoading = false;
                        imgPath = null;
                      });
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // prof page
                          CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(allUserDataFromDB!.profImg)),
                          const SizedBox(width: 16), // مسافة بين الصورة والنص
                          Expanded(
                            child: TextField(
                              controller: descriptionController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: "Write a Caption...",
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 20), // مسافة بين الصف وأيقونة الصورة المصغرة
                      Center(
                        child: Container(
                          width: widthScreen,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(20), // حواف دائرية مميزة
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4), // يعطي عمق للصورة المصغرة
                              ),
                            ],
                            image: DecorationImage(
                              image: MemoryImage(imgPath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isLoading
                          ? const LinearProgressIndicator(
                              color: Colors.blue,
                            )
                          : Divider(
                              thickness: 1,
                              color: Colors.blue.withOpacity(0.2),
                              height: 30,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
            decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
              child: Center(
                child: TextButton(
                    onPressed: () {
                      showImageSourceOptions();
                    },
                    child: const Text(
                      "Add photo 🥰",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
            ),
          );
  }
}
