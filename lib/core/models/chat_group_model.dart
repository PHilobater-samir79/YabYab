class ChatGroupModel {
  String groupId;
  String groupName;
  List members;
  String groupImage;
  List admins;
  String lastMessage;
  String lastMessageTime;
  String createdAt;

  ChatGroupModel(
      {required this.groupId,
      required this.groupName,
      required this.members,
      required this.groupImage,
      required this.admins,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.createdAt});

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
        groupId: json['groupId'],
        groupName: json['groupName'],
        members: json['members'],
        groupImage: json['groupImage'],
        admins: json['admins'],
        lastMessage: json['lastMessage'],
        lastMessageTime: json['lastMessageTime'],
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'members': members,
      'groupImage': groupImage,
      'admins': admins,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt
    };
  }
}
