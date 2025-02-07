import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
final String profImg;
final String userName;
final String description;
final String imgPost;
final String uid;
final String postId;
final DateTime postDate;
final List likes;


  PostData(
      {required this.userName,
      required this.description,
      required this.imgPost,
      required this.postId,
      required this.profImg,
      required this.uid,
      required this.postDate,
      required this.likes,
      
      });

// convert data to map to can use in fire base
  Map<String, dynamic> convertdata2map() {
    return {
      "userName": userName,
      "description": description,
      "imgPost": imgPost,
      "postId": postId,
      "profImg": profImg,
      "Uid": uid,
    "postData": postDate,
    "likes":likes,
    };
  }


 
 static convertdata2Model(DocumentSnapshot snap) {
 var data = snap.data() as Map<String, dynamic>;
 return PostData(
  userName: data["userName"],
  profImg: data["profImg"],
  imgPost: data["imgPost"],
  description: data["description"],
  postId: data["postId"],
  uid: data["Uid"],
  postDate: data["postDate"],
  likes: data["likes"],
  
  
  );
 }

}
