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

  UserData({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.profImg,
    required this.uid,
    required this.followers,
    required this.following,
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
    };
  }

  // Convert Firestore document to UserData model
  static UserData? convertdata2Model(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>?;

    // Ensure data is not null before using it
    if (data == null) {
      return null; // or handle as appropriate
    }

    // Fallback values in case any field is missing
    return UserData(
      userName: data["userName"] ?? '',
      phoneNumber: data["phoneNumber"] ?? '',
      email: data["email"] ?? '',
      password: data["password"] ?? '',
      profImg: data["profImg"] ?? '',
      uid: data["uid"] ?? '',
      followers: data["followers"] ?? [],
      following: data["following"] ?? [],
    );
  }
}
