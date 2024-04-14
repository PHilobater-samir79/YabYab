class ChatRooomModel {
  String? chatRoomId;
  String? lastMessage;
  String? lastMessageTime;
  String? createdAt;
  List? members;

  ChatRooomModel(
      {required this.chatRoomId,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.createdAt,
      required this.members});

  factory ChatRooomModel.fromJson(Map<String, dynamic> json) {
    return ChatRooomModel(
        chatRoomId: json['chatRoomId'],
        lastMessage: json['lastMessage'],
        lastMessageTime: json['lastMessageTime'],
        createdAt: json['createdAt'],
        members: json['members']);
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
      'members': members
    };
  }
}
