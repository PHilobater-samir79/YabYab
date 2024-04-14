import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String password, email, userName, userProfileImage, uid;
  final List followers, following, stories;

  UsersModel(
      {required this.password,
      required this.email,
      required this.userName,
      required this.userProfileImage,
      required this.uid,
      required this.followers,
      required this.stories,
      required this.following});

  Map<String, dynamic> convertToMap() {
    return {
      'password': password,
      'email': email,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'uid': uid,
      'followers': followers,
      'following': following,
      'stories': stories
    };
  }

  static convertSnapToModel(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UsersModel(
        password: snapshot['password'],
        email: snapshot['email'],
        userName: snapshot['userName'],
        userProfileImage: snapshot['userProfileImage'],
        uid: snapshot['uid'],
        stories: snapshot['stories'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
