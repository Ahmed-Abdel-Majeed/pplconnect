import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String userName;
  String phoneNumber;
  String email;
  String password;
  String profImg;
  String uid;
  List<dynamic> followers;
  List<dynamic> following;
  int unreadMessages; // Change to int

  UserData({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.profImg,
    required this.uid,
    required this.followers,
    required this.following,
    this.unreadMessages = 0, // Default to 0
  });

  // Convert data to map to use in Firebase
  Map<String, dynamic> convertdata2map() {
    return {
      "userName": userName,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "profImg": profImg,
      "uid": uid,
      "followers": followers,
      "following": following,
      "unreadMessages": unreadMessages,
    };
  }

  // Convert Firestore document to UserData model
  static UserData? convertdata2Model(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>?;

    if (data == null) {
      return null;
    }

    return UserData(
      userName: data["userName"] ?? '',
      phoneNumber: data["phoneNumber"] ?? '',
      email: data["email"] ?? '',
      password: data["password"] ?? '',
      profImg: data["profImg"] ?? '',
      uid: data["uid"] ?? '',
      followers: data["followers"] ?? [],
      following: data["following"] ?? [],
      unreadMessages: data["unreadMessages"] ?? 0,
    );
  }
}