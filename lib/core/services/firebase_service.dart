
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../data/models/user_data.dart';
import '../providers/user_provider.dart';
import '../utils/snackbar.dart';
import 'storage.dart';

class AuthService {
Future<void> register({
  required String emailAddress,
  required String password,
  required context,
  required String userName,
  required String phoneNumber,
  required imgPath,
  required imgName,
}) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    String profImg;
    try {
      profImg = await StorageData().getImges(imgName: imgName, imgPath: imgPath, folderName: "ProfileImg");
    } catch (e) {
      showSnackBar(context, "Error uploading image: $e");
      return;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('Userss');
    UserData userData = UserData(
      userName: userName,
      phoneNumber: phoneNumber,
      email: emailAddress,
      profImg: profImg,
      uid: credential.user!.uid,
      followers: [],
      following: [],
      password: password,
    );

    await users.doc(credential.user!.uid).set(userData.convertdata2map());

    // Provider.of<UserProvider>(context, listen: false).setUser(userData);

    showSnackBar(context, "Registered & User Added to DB ♥");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'weak-password':
        showSnackBar(context, "The password provided is too weak.");
        break;
      case 'email-already-in-use':
        showSnackBar(context, "The account already exists for that email.");
        break;
      default:
        showSnackBar(context, "ERROR - ${e.code}");
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}

Future<void> signIn({required emailAddress, required password, required context}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    Provider.of<UserProvider>(context, listen: false).refreshUser();
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, "ERROR: ${e.code}");
  } catch (e) {
    showSnackBar(context, "ERROR: $e");
  }
}

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  
  
  Future<UserData?> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Userss')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserData.convertdata2Model(snap);
  }







}
