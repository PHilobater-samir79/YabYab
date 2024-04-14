class ChatUserModel {
  final String createdAt, lastActivated, pushToken, about;
  final String password, email, userName, userProfileImage, uid;
  final bool online;

  ChatUserModel(
      {required this.createdAt,
      required this.password,
      required this.email,
      required this.userName,
      required this.userProfileImage,
      required this.uid,
      required this.lastActivated,
      required this.pushToken,
      required this.about,
      required this.online});

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'email': email,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'uid': uid,
      'createdAt': createdAt,
      'lastActivated': lastActivated,
      'pushToken': pushToken,
      'about': about,
      'online': online
    };
  }

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
        password: json['password'],
        email: json['email'],
        userName: json['userName'],
        userProfileImage: json['userProfileImage'],
        uid: json['uid'],
        createdAt: json['createdAt'],
        lastActivated: json['lastActivated'],
        pushToken: json['pushToken'],
        about: json['about'],
        online: json['online']);
  }
}
